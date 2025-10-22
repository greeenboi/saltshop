class ApplicationMailer < ActionMailer::Base
  # Use a sensible default sender; prefer an env var, fallback to Gmail username
  default from: ENV["MAILER_FROM"].presence || ENV["GMAIL_USERNAME"] || "ir0270@srmist.edu.in"
  layout "mailer"
end
