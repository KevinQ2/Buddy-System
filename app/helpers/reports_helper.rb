module ReportsHelper

def status(report)
    if report.handled == false
        "Not Handled"
    else
        "Handled"
    end
end

end
