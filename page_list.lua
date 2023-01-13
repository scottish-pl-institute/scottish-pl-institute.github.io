function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end
function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end
return {
  {
    Pandoc = function(pdoc)
      entry = string.format("[%s](/%s.html)\n", pandoc.utils.stringify(pdoc.meta.title), string.gsub(string.gsub(string.gsub(PANDOC_STATE.input_files[1],"%..*",""), "^pages/",""), "00%-index","index"))
      if not file_exists("page_list.md") then 
         file = io.open("page_list.md", "w")
         io.output(file)
         io.write("---\ntitle: \"Archive\"\n---\n");
         io.close(file)
      end
      file = io.open("page_list.md","a")
      io.output(file)
      io.write(entry)
      io.close(file)
      return pandoc.Pandoc({})
    end,
  }
}
