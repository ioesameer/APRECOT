function [tas] = cas2tas(cas,d)
d0=1.225;
tas = sqrt(d0./d).*cas;
end

