class BirthdateValidator < ActiveModel::EachValidator
    def validate_each record, attribute, value
        age = (Date.today - value).to_i/365
        minimum_age = options[:minimum_age].is_a?(Integer) ? options[:minimum_age] : 0;
        maximum_age = options[:maximum_age].is_a?(Integer) ? options[:maximum_age] : nil;

        if minimum_age != nil
            unless age >= minimum_age
                if minimum_age == 0
                    record.errors.add(attribute, options[:message] || :invalid_birthdate)
                else
                    m_identifier = "too_young.#{minimum_age.abs == 1 ? :one : :other}";
                    record.errors[attribute] << (options[:message] || record.m(attribute, m_identifier, age: minimum_age))
                end
            end
        end

        if maximum_age != nil
            unless age <= maximum_age
                m_identifier = "too_old.#{minimum_age.abs == 1 ? :one : :other}";
                record.errors[attribute] << (options[:message] || record.m(attribute, m_identifier, age: maximum_age))
            end
        end
    end
end
