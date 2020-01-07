module OmniAuthHelpers
  def set_omniauth(service = :twitter)
    OmniAuth.config.test_mode = true

    OmniAuth.config.mock_auth[service] = OmniAuth::AuthHash.new({
      provider: service.to_s,
      uid: '1234',
      info: {
        name: 'mockuser',
        image: "https://test.com/test.png"
      }
      })
  end
end