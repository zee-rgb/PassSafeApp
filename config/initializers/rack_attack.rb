# Basic Rack::Attack throttles
# Docs: https://github.com/rack/rack-attack

class Rack::Attack
  # Allow all local traffic
  safelist("allow-localhost") { |req| ["127.0.0.1", "::1"].include?(req.ip) }

  # Throttle login attempts by IP
  # e.g., max 5 reqs in 20 seconds (adjust as needed)
  throttle("logins/ip", limit: 5, period: 20.seconds) do |req|
    if req.path =~ %r{^/[a-z]{2}/secure/sign_in$} && req.post?
      req.ip
    end
  end

  # Throttle password reset by IP
  throttle("password_reset/ip", limit: 5, period: 20.seconds) do |req|
    if req.path =~ %r{^/[a-z]{2}/secure/password$} && req.post?
      req.ip
    end
  end

  # Throttle sensitive reveal endpoints by IP
  throttle("entries/reveal/ip", limit: 10, period: 60.seconds) do |req|
    if req.post? && req.path =~ %r{^/[a-z]{2}/entries/\d+/(reveal_username|reveal_password)$}
      req.ip
    end
  end

  # Optionally, add a global request throttle
  # throttle("req/ip", limit: 300, period: 5.minutes) { |req| req.ip }
end
