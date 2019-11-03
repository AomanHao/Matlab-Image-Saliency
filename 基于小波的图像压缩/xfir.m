function X = xfir(B,Z,X,Ext)
%XFIR  Noncausal FIR filtering with boundary handling.
%   Y = XFIR(B,Z,X,EXT) filters X with FIR filter B with leading
%   delay -Z along the columns of X.  EXT specifies the  boundary
%   handling.  Special handling  is done for one and two-tap filters.

% Pascal Getreuer 2005-2006

N = size(X);

% Special handling for short filters
if length(B) == 1 & Z == 0
   if B == 0
      X = zeros(size(X));
   elseif B ~= 1
      X = B*X;
   end
   return;
end

% Compute the number of samples to add to each end of the signal
pl = max(length(B)-1-Z,0);       % Padding on the left end
pr = max(Z,0);                   % Padding on the right end

switch lower(Ext)
case {'sym','wsws'}   % Symmetric extension, WSWS
   if all([pl,pr] < N(1))
         X = filter(B,1,X([pl+1:-1:2,1:N(1),N(1)-1:-1:N(1)-pr],:,:),[],1);
         X = X(Z+pl+1:Z+pl+N(1),:,:);
      return;
   else
      i = [1:N(1),N(1)-1:-1:2];
      Ns = 2*N(1) - 2 + (N(1) == 1);
      i = i([rem(pl*(Ns-1):pl*Ns-1,Ns)+1,1:N(1),rem(N(1):N(1)+pr-1,Ns)+1]);
   end
case {'symh','hshs'}  % Symmetric extension, HSHS
   if all([pl,pr] < N(1))
      i = [pl:-1:1,1:N(1),N(1):-1:N(1)-pr+1];
   else
      i = [1:N(1),N(1):-1:1];
      Ns = 2*N(1);
      i = i([rem(pl*(Ns-1):pl*Ns-1,Ns)+1,1:N(1),rem(N(1):N(1)+pr-1,Ns)+1]);
   end
case 'wshs'           % Symmetric extension, WSHS
   if all([pl,pr] < N(1))
      i = [pl+1:-1:2,1:N(1),N(1):-1:N(1)-pr+1];
   else
      i = [1:N(1),N(1):-1:2];
      Ns = 2*N(1) - 1;
      i = i([rem(pl*(Ns-1):pl*Ns-1,Ns)+1,1:N(1),rem(N(1):N(1)+pr-1,Ns)+1]);
   end
case 'hsws'           % Symmetric extension, HSWS
   if all([pl,pr] < N(1))
      i = [pl:-1:1,1:N(1),N(1)-1:-1:N(1)-pr];
   else
      i = [1:N(1),N(1)-1:-1:1];
      Ns = 2*N(1) - 1;
      i = i([rem(pl*(Ns-1):pl*Ns-1,Ns)+1,1:N(1),rem(N(1):N(1)+pr-1,Ns)+1]);
   end
case 'zpd'
   Ml = N; Ml(1) = pl;
   Mr = N; Mr(1) = pr;
   
   X = filter(B,1,[zeros(Ml);X;zeros(Mr)],[],1);
   X = X(Z+pl+1:Z+pl+N(1),:,:);
   return;
case 'per'            % Periodic
   i = [rem(pl*(N(1)-1):pl*N(1)-1,N(1))+1,1:N(1),rem(0:pr-1,N(1))+1];
case 'sp0'            % Constant extrapolation
   i = [ones(1,pl),1:N(1),N(1)+zeros(1,pr)];
case 'asym'           % Asymmetric extension
   i1 = [ones(1,pl),1:N(1),N(1)+zeros(1,pr)];

   if all([pl,pr] < N(1))
      i2 = [pl+1:-1:2,1:N(1),N(1)-1:-1:N(1)-pr];
   else
      i2 = [1:N(1),N(1)-1:-1:2];
      Ns = 2*N(1) - 2 + (N(1) == 1);
      i2 = i2([rem(pl*(Ns-1):pl*Ns-1,Ns)+1,1:N(1),rem(N(1):N(1)+pr-1,Ns)+1]);
   end
   
   X = filter(B,1,2*X(i1,:,:) - X(i2,:,:),[],1);
   X = X(Z+pl+1:Z+pl+N(1),:,:);
   return;
otherwise
   error(['Unknown boundary handling, ''',Ext,'''.']);
end

X = filter(B,1,X(i,:,:),[],1);
X = X(Z+pl+1:Z+pl+N(1),:,:);
return;
