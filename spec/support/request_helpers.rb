# frozen_string_literal: true

module RequestHelpers
    def auth_params(user)
      post("/api/auth/sign_in", params: {
        email: user.email,
        password: user.password,
      })
  
      client = response.headers["client"]
      token = response.headers["access-token"]
      expiry = response.headers["expiry"]
      uid = response.headers["uid"]
  
      {
        "access-token" => token,
        "client" => client,
        "uid" => uid,
        "expiry" => expiry,
      }
    end
end