# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self, :https
    policy.font_src    :self, :https, :data
    policy.img_src     :self, :https, :data
    policy.object_src  :none
    policy.frame_ancestors :none
    # Importmap/Turbo operate as module scripts; allow self + https with nonces + unsafe-inline
    policy.script_src  :self, :https, :unsafe_inline
    policy.style_src   :self, :https, :unsafe_inline
    # XHR/Fetch destinations (Turbo Streams, APIs)
    policy.connect_src :self, :https
    # Websockets only in development; production behind HTTPS reverse proxies typically not needed
    # policy.websocket_src :self
    # Specify URI for violation reports if desired
    # policy.report_uri "/csp-violation-report-endpoint"
  end

  # Generate session nonces for permitted importmap, inline scripts, and inline styles.
  config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  config.content_security_policy_nonce_directives = %w[script-src style-src]

  # Report-only mode example:
  # config.content_security_policy_report_only = true
end
