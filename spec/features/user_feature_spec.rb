require 'rails_helper'

describe User do
  let!(:user) { create(:user) }

  describe "the sign up process" do
    before :each do
      visit new_user_registration_path
    end

    it "signs up user" do
      fill_in "Email", with: "testuser123@test.com"
      fill_in "Username", with: "testuser123"
      fill_in "Password", with: "password123"
      fill_in "Password confirmation", with: "password123"
      click_button "Sign up"
      expect(page).to have_content "Welcome! You have signed up successfully."
      expect(page).to have_content "testuser123"
      expect(page).to have_link "Sign out"
    end

    it "blocks user with invalid email" do
      fill_in "Email", with: "testuser123"
      fill_in "Username", with: "testuser123"
      fill_in "Password", with: "password123"
      fill_in "Password confirmation", with: "password123"
      click_button "Sign up"
      expect(page).to have_content "Email is invalid"
    end

    it "blocks user trying to use the same username" do
      fill_in "Email", with: "testuser123@test.com"
      fill_in "Username", with: "testuser"
      fill_in "Password", with: "password123"
      fill_in "Password confirmation", with: "password123"
      click_button "Sign up"
      expect(page).to have_content "Username has already been taken"
    end

    it "blocks user trying to use the same email" do
      fill_in "Email", with: "test@test.com"
      fill_in "Username", with: "testuser123"
      fill_in "Password", with: "password123"
      fill_in "Password confirmation", with: "password123"
      click_button "Sign up"
      expect(page).to have_content "Email has already been taken"
    end

    it "blocks user tyring to use password less than 6 characters" do
      fill_in "Email", with: "testuser123@test.com"
      fill_in "Username", with: "testuser123"
      fill_in "Password", with: "12345"
      fill_in "Password confirmation", with: "12345"
      click_button "Sign up"
      expect(page).to have_content "Password is too short (minimum is 6 characters)"
    end
  end

  describe "the sign in process" do
    before :each do
      visit new_user_session_path
    end

    it "signs in user with email" do
      fill_in "Login", with: user.email
      fill_in "Password", with: "123456"
      click_button "Log in"
      expect(page).to have_content "Signed in successfully."
      expect(page).to have_content user.username
    end

    it "signs in user with username" do
      fill_in "Login", with: user.username
      fill_in "Password", with: "123456"
      click_button "Log in"
      expect(page).to have_content "Signed in successfully."
      expect(page).to have_content user.username
    end

    it "blocks unauthorized user" do
      fill_in "Login", with: "unauthorized_user"
      fill_in "Password", with: "123456"
      click_button "Log in"
      expect(page).to have_content "Invalid Login or password"
    end

    it "blocks user with wrong password" do
      fill_in "Login", with: user.username
      fill_in "Password", with: "incorrect_password"
      click_button "Log in"
      expect(page).to have_content "Invalid Login or password"
    end
  end

  describe "the sign out process" do
    before :each do
      login_as(user, scope: :user)
      visit stocks_path
    end

    it "signs out the user" do
      click_link "Sign out"
      expect(page).to have_content "Signed out successfully"
    end
  end
end