require 'spec_helper'
require 'capybara/rspec'

describe "User Pages" do


  subject { page }

  describe "with Org Admin" do
    let(:org_admin_user) { FactoryGirl.create(:org_admin) }
    let(:org) { org_admin_user.organization }

    before(:each) { sign_in org_admin_user }

    describe "successful login" do

      # todo add I18n to string to the text
      it { should have_selector('.alert', text: 'successfully') }
      it { should have_link('sign_out_header_link') }
      it { should have_link('profile_header_link') }

    end

    describe "successful logout" do
      # todo add I18n to string to the text
      before { click_link 'sign_out_header_link' }
      it { should have_selector('.alert', text: 'successfully') }
      it { should have_link('sign_in_header_link') }
    end

    describe "failed login" do

      before do
        click_link 'sign_out_header_link'
        click_link 'sign_in_header_link'
        fill_in 'user_email', with: org_admin_user.email
        fill_in 'user_password', with: 'wrong_password'
        click_button 'Sign in'

      end
      # todo add I18n to string to the text
      it { should have_selector('.alert', text: 'Invalid') }
      it { should have_link('sign_in_header_link') }
    end

    describe "home page" do
      pending "create home page"
    end

    describe "profile page" do
      before { visit profile_path }

      it { should have_selector('h1', text: 'Profile') }
      it { should have_selector('#org_details') }
      it { should have_selector('#org_users') }
      it { should have_selector('#add_user_button') }
      it { should have_selector('#reset_password') }
      describe "add a user button" do
        before do
          click_link 'add_user_button'
        end

        it { should have_selector('h1', text: 'User') }
        it { should_not have_selector('#user_role_ids_1') }
      end
      describe "password change" do
        before { click_link 'reset_password' }

        it { should have_selector('#user_email') }

        describe "with matching password" do
          before do
            fill_in 'user_password', with: 'foobar'
            fill_in 'user_password_confirmation', with: 'foobar'
            fill_in 'user_current_password', with: org_admin_user.password
            click_button 'update_user'
          end

          it { should have_selector('.alert-success') }

        end
        describe "with un-matching password" do
          before do
            fill_in 'user_password', with: 'foobar'
            fill_in 'user_password_confirmation', with: 'wrong'
            fill_in 'user_current_password', with: org_admin_user.password
            click_button 'update_user'
          end

          it { should have_selector('.alert-error') }
          it { should have_selector('.password.error') }


        end
        describe "with wrong current password" do
          before do
            fill_in 'user_password', with: 'foobar'
            fill_in 'user_password_confirmation', with: 'foobar'
            fill_in 'user_current_password', with: 'wrong'
            click_button 'update_user'
          end

          it { should have_selector('.alert-error') }
          it { should have_selector('.password.error') }


        end


      end

    end

    describe "add a user" do
      before do
        visit new_my_user_path
      end
      describe "valid dispatcher " do
        before do
          fill_in 'user_email', with: "dispatcher@test.com"
          fill_in 'user_password', with: 'foobar'
          fill_in 'user_password_confirmation', with: 'foobar'
          check 'user_role_ids_3'
          click_button 'create_user_button'
        end

        it { should have_selector('.alert', text: 'successfully') }
        it { should have_selector('#users') }
        it { should have_content('dispatcher@test.com') }
      end
      describe "valid technician" do
        before do
          fill_in 'user_email', with: "technician@test.com"
          fill_in 'user_password', with: 'foobar'
          fill_in 'user_password_confirmation', with: 'foobar'
          check 'user_role_ids_4'
          click_button 'create_user_button'
        end

        it { should have_selector('.alert', text: 'successfully') }
        it { should have_selector('#users') }
        it { should have_content('technician@test.com') }
      end
      describe "valid org admin" do
        before do
          fill_in 'user_email', with: "org_admin@test.com"
          fill_in 'user_password', with: 'foobar'
          fill_in 'user_password_confirmation', with: 'foobar'
          check 'user_role_ids_2'
          click_button 'create_user_button'
        end

        it { should have_selector('.alert', text: 'successfully') }
        it { should have_selector('#users') }
        it { should have_content('org_admin@test.com') }
      end
      describe "with multiple roles" do
        before do
          fill_in 'user_email', with: "multiple_roles@test.com"
          fill_in 'user_password', with: 'foobar'
          fill_in 'user_password_confirmation', with: 'foobar'
          check 'user_role_ids_2'
          check 'user_role_ids_3'
          check 'user_role_ids_4'
          click_button 'create_user_button'
        end

        it { should have_selector('.alert', text: 'successfully') }
        it { should have_selector('#users') }
        it { should have_content('multiple_roles@test.com') }
      end
      describe "with no role" do
        before do
          fill_in 'user_email', with: "dispatcher@test.com"
          fill_in 'user_password', with: 'foobar'
          fill_in 'user_password_confirmation', with: 'foobar'
          click_button 'create_user_button'
        end

        it { should have_selector('.error') }
      end
    end


  end

  describe "with owner user" do
    pending
  end

  describe "with dispatcher" do
    pending
  end

end