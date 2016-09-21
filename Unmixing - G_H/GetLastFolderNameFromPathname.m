function name = GetLastFolderNameFromPathname(pathname)
j = 0;
for i = 1:size(pathname,2)
    if (pathname(i) == filesep)
        j = j + 1;
        s(j) = i;
    end
end
if pathname(end) == filesep
    name = pathname( (s(end-1)+1) : (s(end) - 1));
else
    name = pathname( (s(end)+1) : end);
end

