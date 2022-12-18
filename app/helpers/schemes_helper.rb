module SchemesHelper

    def isValidEditDate(schemeDate)
        if DateTime.current.to_date < schemeDate
            true
        else
            false
        end
    end
end
