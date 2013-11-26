require 'spec_helper'

# selector constants
INPUT_MATERIAL_NAME        = 'material_name'
INPUT_MATERIAL_DESCRIPTION = 'material_description'
INPUT_MATERIAL_COST        = 'material_cost'
INPUT_MATERIAL_PRICE       = 'material_price'
BTN_CREATE_MATERIAL        = 'create-material-btn'

describe 'Material Pages', js: true do
  self.use_transactional_fixtures = false

  setup_org


  before do
    in_browser(:org) do
      sign_in org_admin_user
    end
  end

  subject { page }

  describe 'material index' do

    before do
      visit materials_path
    end

    it 'should show a new part form' do
      should have_selector '#new_material'
    end

    describe 'create material' do
      before do
        fill_in INPUT_MATERIAL_NAME, with: 'TEST MATERIAL'
        fill_in INPUT_MATERIAL_DESCRIPTION, with: 'TEST DESCRIPTION'
        fill_in INPUT_MATERIAL_COST, with: 'TEST DESCRIPTION'
        fill_in INPUT_MATERIAL_PRICE, with: 'TEST DESCRIPTION'
        click_button BTN_CREATE_MATERIAL
      end

      it 'should show the material in the materials table' do
        should have_selector 'tbody#materials tr', count: 1, text: 'TEST MATERIAL'
      end

      describe 'delete material' do

        before do
          # to prevent the "Are You Sure? popup
          page.evaluate_script('window.confirm = function() { return true; }')
          click_link 'Delete'
        end

        it 'should show no materials in the materials table' do
          should have_selector 'tbody#materials'
          should have_selector 'tbody#materials tr', count: 0
        end

      end

    end

  end
end