class ApplicationMailer < ActionMailer::Base
  # Use a sensible default sender; prefer an env var, fallback to Gmail username, then generic placeholder
  default from: ENV["MAILER_FROM"].presence || ENV["GMAIL_USERNAME"] || "noreply@example.com"
  layout "mailer"
end
