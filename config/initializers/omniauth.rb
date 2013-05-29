OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '446451938769749', '7e67a1173177a17d9774812138092a8f', {:scope => 'publish_actions'}
  provider :twitter, 'lwriQjeyfOMojlldOQbiZQ', 'GD9olZVUib7uSpqXEut1bczCbpltsu5x7a6FfazcOE'


  Twitter.configure do |config|
    config.consumer_key = 'lwriQjeyfOMojlldOQbiZQ'
    config.consumer_secret = 'GD9olZVUib7uSpqXEut1bczCbpltsu5x7a6FfazcOE'
    config.oauth_token = '14387745-2lYByp052zlAyWFopVB6g5xjtI5DsZGPPAQyPWPJG'
    config.oauth_token_secret = 'vdpHOupNhuubeRDC2IUOMqCAYjgx5rg3peoNffaomeg'
  end
end
