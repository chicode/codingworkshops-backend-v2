defmodule Workshops.Guardian do
  use Guardian, otp_app: :workshops

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(claims) do
    {:ok, Workshops.Repo.get!(Workshops.User, claims["sub"])}
  end
end
