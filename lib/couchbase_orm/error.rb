# frozen_string_literal: true

module CouchbaseOrm
  class Error < ::StandardError
    attr_reader :record

    def initialize(message = nil, record = nil)
      @record = record
      super(message)
    end

    class RecordInvalid < Error
      def initialize(message = nil, record = nil)
        if record
          errors = record.errors.full_messages.join(', ')
          message = I18n.t(
            :"couchbase.#{record.class.design_document}.errors.messages.record_invalid",
            errors: errors,
            default: :'couchbase.errors.messages.record_invalid'
          )
        end
        super(message, record)
      end
    end

    class TypeMismatchError < Error; end
    class RecordExists < Error; end
    class EmptyNotAllowed < Error; end
  end
end
