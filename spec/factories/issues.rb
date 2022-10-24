FactoryBot.define do
  factory :issue, class: "::Issue::Record" do
    title { "Title"}
    number { "1" }
  end
end
