function s = filterstr(a,K)
% Convert a filter to a string

[n,d] = rat(K/sqrt(2));

if d < 50
   a{1} = a{1}/sqrt(2);   % Scale filter by sqrt(2)
   s = '( ';
else
   s = '';
end

Scale = [pow2(1:15),10,20,160,280,inf];

for i = 1:length(Scale)
   if norm(round(a{1}*Scale(i))/Scale(i) - a{1},inf) < 1e-9
      a{1} = a{1}*Scale(i);  % Scale filter by a power of 2 or 160
      s = '( ';
      break;
   end
end

z = a{2};
LineOff = 0;

for k = 1:length(a{1})
   v = a{1}(k);

   if v ~= 0  % Only display nonzero coefficients
      if k > 1
         s2 = [' ',char(44-sign(v)),' '];
         v = abs(v);
      else
         s2 = '';
      end

      s2 = sprintf('%s%g',s2,v);

      if z == 1
         s2 = sprintf('%s z',s2);
      elseif z ~= 0
         s2 = sprintf('%s z^%d',s2,z);
      end

      if length(s) + length(s2) > 72 + LineOff  % Wrap long lines
         s2 = [char(10),'        ',s2];
         LineOff = length(s);
      end

      s = [s,s2];
   end

   z = z - 1;
end

if s(1) == '('
   s = [s,' )'];

   if d < 50, s = [s,' sqrt(2)']; end

   if i < length(Scale)
      s = sprintf('%s/%d',s,Scale(i));
   end
end

return;