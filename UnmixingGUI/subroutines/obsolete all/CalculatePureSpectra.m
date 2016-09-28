%% calculate pure spectra
function sPure = CalculatePureSpectra(sMixed, sAuto, NR_Delegate Func, fitOffset)
%private float[] Calculate_Pure_Spectra(float[] sMixed, float[] sAuto,
%NR_Delegate Func, bool fitOffset

sPure = zeros(size(sMixed));
if(fitOffset)
    output = fminsearch(Func,new float[2] {1, -5});
else
    output = fminsearch(Func,new float[1] {1});
end

for w = 1:length(sPure)

    mag = output(1);
    if(length(output) > 1)
        off = output(2);
    else
        off = 0;
    end

    sPure(w) = sMixed(w) + off - mag * sAuto(w);
end

function float = Autoflerr(y)
	
expcoeff = 1;
ignore_err = 0.01;
mag = y(1);
off;
err;

if ( length(y) > 1 )
    off = y(2);
else
    off = 0;
end

    diffspec = sMixed + off - mag * sAuto;
    diffspecerr = diffspec ./ sqrt(sMixed);
    for i = 1:N
        if abs(diffspecerr) > ignore_err 
            diffspecerr2(i) = diffspecerr[i];
        else
            diffspecerr2(i) = 0;
        end
    end
    
    err = 0;
    for(int w = 0; w < diffspecerr2.Length; w++)
        err = err + ( exp( -expcoeff * diffspecerr2) + 1 ) .* ( diffspecerr2.^2 );
    end
end

(Math.Exp(-expcoeff*diffspecerr2[w])+1)*(float)Math.Pow(diffspecerr2[w],2);


            
function array NormalizeSpectrum(array)
m = max(array);
if m > 0
    array = array/m;
else
    array = 0;
end