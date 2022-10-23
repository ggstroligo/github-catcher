class BaseStruct < Dry::Struct
  Type = Module.new.include(Dry.Types())

  transform_keys(&:to_sym)

  def self.with_timestamps
    attribute :created_at, Type::Nominal::DateTime.optional
    attribute :updated_at, Type::Nominal::DateTime.optional
  end
end