for i = 1, #FountainsAndAltarsDB do
    if FountainsAndAltarsDB[i] ~= nil then
        local autonoteId   = ":" .. FountainsAndAltarsDB[i].ID
        local autonoteText = Fountain_GetAutonoteText(FountainsAndAltarsDB[i])

        if autonoteText ~= nil and autonoteText:match("^%s*(.-)%s*$") ~= "" then
            Autonote(autonoteId, 1, autonoteText)
        end
    end
end
