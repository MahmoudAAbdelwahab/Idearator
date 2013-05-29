# Relatively simple similarity index calculation based on:
# 1- Jaccard set similarity of tags
# 2- Jaccard set similarity of keywords in the title, where keywords are simply
#      defined as words that are at least KEYWORD_LENGTH (currently 5) long
# 3- Hamming distance between the simhashes of title, description and
#      problem solved

require 'set'

class SimilarityEngine

  # Shingle lengths for Title, Description and Problem Solved
  DEFAULT_SHINGLE_LEN = 3
  DESC_SHINGLE_LEN = 3
  PROB_SHINGLE_LEN = 3
  TITLE_SHINGLE_LEN = 4

  # Minimum length of a word to be considered a keyword in the title
  KEYWORD_LENGTH = 5

  # Weighing model
  SIMILARITY_MODEL = {
    tags_jacc_idx:           10,
    title_keywords_jacc_idx: lambda { |x| 6**x - 1 },
    title_hamming_dist:      lambda { |x| 11**x - 1 },
    desc_hamming_dist:       8,
    prob_hamming_dist:       8
  }

  class << self
    build_after_idea_save = true
    attr_accessor :build_after_idea_save
  end

  # Hook to recalculate the similarity coefficients for an idea upon saving
  class IdeaHooks
    #FIXME delayed_job?
    def after_save(idea)
      SimilarityEngine.rebuild_similarities(idea) if SimilarityEngine.build_after_idea_save
    end
  end

  # Break a string into its constituent n-gram shingles
  #
  # Params:
  # +str+:: +String+ to shingle
  # +ngram_len+:: the length of each shingle
  #
  # Author: Mina Nagy
  def self.shingle(str, ngram_len = DEFAULT_SHINGLE_LEN)
    ngrams = Set.new
    return ngrams if str.nil? || str.length < ngram_len
    (str.length - ngram_len+1).times do |i|
      ngrams << str[i, ngram_len]
    end
    ngrams
  end

  # Calculate the jaccard index of two sets
  # This is a coefficient between 0 (disjoint sets) and 1 (same set)
  #
  # Params:
  # +a+:: the first set
  # +b+:: the second set
  #
  # Author: Mina Nagy
  def self.jaccard_index(a, b)
    return 0 if a.empty? && b.empty?
    (a & b).size.to_f / (a | b).size
  end

  # Calculate the 32bit simhash of a string
  # This is a hash with the property that 'similar' strings produce 'similar'
  # hash values
  #
  # Params:
  # +str+:: the string to hash
  #
  # Author: Mina Nagy
  def self.simhash(str, ngram_len = DEFAULT_SHINGLE_LEN)
    v = [0] * 32
    shingle(str, ngram_len).each do |sh|
      sh = sh.hash
      32.times do |i|
        if (sh & 1) == 1
          v[i] += 1
        else
          v[i] -= 1
        end
        sh >>= 1
      end
    end

    res = 0
    32.times do |i|
      res |= 1 if v[i] > 0
      res <<= 1
    end
    res
  end

  # Calculate the normalized hamming distance between two Fixnums
  # Assuming 32bit integers
  # this uses the builtin String#count instead of doing a manual population
  # count because this is apparently faster. Ruby. Go figure.
  #
  # Params:
  # +a+:: first +Fixnum+
  # +b+:: second +Fixnum+
  #
  # Author: Mina Nagy
  def self.hamming_distance(a, b, width = 32)
    return 0 if a == b && b == 0
    1.0 - ((a ^ b).to_s(2).count('1') / width.to_f)
  end


  # Split a string into a set of hashed keywords
  # Keywords are currently defined as words more than KEYWORD_LENGTH chars in length
  # The idea is that such a keyword can be considered as important as a tag if
  # it is common between two Idea titles.
  #
  # Params:
  # +str+:: the +String+ to split
  #
  # Author: Mina Nagy
  def self.hashed_keywords(str)
    return [] if str.nil?
    str = str.split
    str.reject! { |s| s.length <= KEYWORD_LENGTH }
    str.map(&:hash).to_set
  end

  # Calculate the compound similarity coeff weighted according to the
  # SIMILARITY_MODEL class constant
  #
  # Params:
  # +idea1+:: first +Idea+
  # +idea2+:: second +Idea+
  #
  # Author: Mina Nagy
  def self.idea_similarity_coeff(idea1, idea2)
    vals = {
      tags_jacc_idx:           jaccard_index(idea1.tag_ids, idea1.tag_ids),
      title_keywords_jacc_idx: jaccard_index(hashed_keywords(idea1.title),
                                             hashed_keywords(idea2.title)),
      title_hamming_dist:      hamming_distance(simhash(idea1.title, TITLE_SHINGLE_LEN),
                                                simhash(idea2.title, TITLE_SHINGLE_LEN)),
      desc_hamming_dist:       hamming_distance(simhash(idea1.description, DESC_SHINGLE_LEN),
                                                simhash(idea2.description, DESC_SHINGLE_LEN)),
      prob_hamming_dist:       hamming_distance(simhash(idea1.problem_solved, PROB_SHINGLE_LEN),
                                                simhash(idea2.problem_solved, PROB_SHINGLE_LEN))
    }

    vals.reduce(0) do |acc, kv|
      model = SIMILARITY_MODEL[kv[0]]
      if [Fixnum, Float].include? model.class
        model * kv[1]
      elsif model.is_a? Proc
        model.call(kv[1])
      end + acc
    end
  end

  # Calculate and store the similarity coeffs for an idea
  #
  # Params:
  # +idea+:: +Idea+ to calculate similarities for
  #
  # Author: Mina Nagy
  def self.rebuild_similarities(idea)
    # find ideas in tagged by the same tags
    ideas_in_tags = Idea.joins(:tags).where(tags: { id: idea.tags })
                    .select('ideas.id, ideas.title, ideas.description, ideas.problem_solved')
                    .preload(:tags)

    similarities = []
    timestamp = Time.now.to_i
    timestamp = "#{timestamp},#{timestamp}"

    # calculate similarity with each idea
    ideas_in_tags.find_each do |similar_idea|
      next if idea.id == similar_idea.id
      similarity = idea_similarity_coeff(idea, similar_idea)

      similarities.push("(#{idea.id},#{similarity},#{similar_idea.id},#{timestamp})," +
                        "(#{similar_idea.id},#{similarity},#{idea.id},#{timestamp})")
    end

    # FIXME what's the proper way to delete?
    stale_ids = Similarity.where('idea_id = ? OR similar_idea_id = ?', idea.id, idea.id).pluck(:id)
    Similarity.delete stale_ids if !stale_ids.empty?

    if !similarities.empty?
      sql = "INSERT INTO similarities (`idea_id`, `similarity`, `similar_idea_id`, `created_at`, `updated_at`)" +
            " VALUES #{similarities.join(",")}"

      Similarity.connection.execute sql
    end
  end

  # Initiate reconstruction of the similarity index for all ideas
  #
  # Params: None
  #
  # Author: Mina Nagy
  def self.rebuild_all_similarities
    Idea.find_each do |idea|
      rebuild_similarities(idea)
    end
  end

end
