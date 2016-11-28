function name = ParsePathname(pathname)
index = strfind(pathname, filesep);
if strcmp(pathname(end), filesep)
    name = pathname(index(end-1)+1:index(end)-1);
else
    name = pathname(index(end)+1:end);
end

    