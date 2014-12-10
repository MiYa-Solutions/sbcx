FactoryGirl.define do
  factory :project, class: Project do
    organization factory: :member_org, strategy: :build
    sequence(:name) { |n| "Test Project #{n}" }
    description 'Test Project Description'

    factory :project_with_jobs, class: Project do
      after(:create) do |project|
        job = FactoryGirl.create(:my_job, organization: project.organization)
        project.tickets << job
        project.tickets << job.dup
      end

      factory :project_jobs_and_customer, class: Project do
        after(:create) do |project|
          project.customer = project.tickets.first.customer
          project.save!
        end
      end

    end
  end
end