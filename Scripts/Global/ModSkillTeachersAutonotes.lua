-- Generate Autonotes for teachers
for i = 1, #TeachersDB do
    if TeachersDB[i] ~= nil and (TeachersDB[i].Autonote ~= nil or TeachersDB[i].Autonote:match("^%s*(.-)%s*$") ~= "" ) then
        Autonote(":"..TeachersDB[i].ID, 5, TeachersDB[i].Autonote)
    end
end
