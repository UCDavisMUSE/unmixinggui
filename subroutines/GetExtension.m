function ext = GetExtension(name)
if length(name) > 3
    ext = name(end-3:end);
else
    ext = [];
end
if isempty(strfind(ext,'.'))
    ext = [];
else
    ext = ext(2:4);
end
