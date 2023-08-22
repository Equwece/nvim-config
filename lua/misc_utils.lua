local vim = vim

function PrintTable(tbl)
  for index, data in ipairs(tbl) do
    print(index)

    for key, value in pairs(data) do
      print('\t', key, value)
    end
  end
end
