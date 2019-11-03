function varargout = wavelet(WaveletName,Level,X,Ext,Dim)
%WAVELET  Discrete wavelet transform.
%   Y = WAVELET(W,L,X) computes the L-stage discrete wavelet transform
%   (DWT) of signal X using wavelet W.  The length of X must be
%   divisible by 2^L.  For the inverse transform, WAVELET(W,-L,X)
%   inverts L stages.  Choices for W are
%     'Haar'                                      Haar
%     'D1','D2','D3','D4','D5','D6'               Daubechies'
%     'Sym1','Sym2','Sym3','Sym4','Sym5','Sym6'   Symlets
%     'Coif1','Coif2'                             Coiflets
%     'BCoif1'                                    Coiflet-like [2]
%     'Spline Nr.Nd' (or 'bior Nr.Nd') for        Splines
%       Nr = 0,  Nd = 0,1,2,3,4,5,6,7, or 8
%       Nr = 1,  Nd = 0,1,3,5, or 7
%       Nr = 2,  Nd = 0,1,2,4,6, or 8
%       Nr = 3,  Nd = 0,1,3,5, or 7
%       Nr = 4,  Nd = 0,1,2,4,6, or 8
%       Nr = 5,  Nd = 0,1,3, or 5
%     'RSpline Nr.Nd' for the same Nr.Nd pairs    Reverse splines
%     'S+P (2,2)','S+P (4,2)','S+P (6,2)',        S+P wavelets [3]
%     'S+P (4,4)','S+P (2+2,2)'
%     'TT'                                        "Two-Ten" [5]
%     'LC 5/3','LC 2/6','LC 9/7-M','LC 2/10',     Low Complexity [1]
%     'LC 5/11-C','LC 5/11-A','LC 6/14',
%     'LC 13/7-T','LC 13/7-C'
%     'Le Gall 5/3','CDF 9/7'                     JPEG2000 [7]
%     'V9/3'                                      Visual [8]
%     'Lazy'                                      Lazy wavelet
%   Case and spaces are ignored in wavelet names, for example, 'Sym4'
%   may also be written as 'sym 4'.  Some wavelets have multiple names,
%   'D1', 'Sym1', and 'Spline 1.1' are aliases of the Haar wavelet.
%
%   WAVELET(W) displays information about wavelet W and plots the
%   primal and dual scaling and wavelet functions.
%
%   重要 For 2D transforms, prefix W with '2D'.  For example, '2D S+P (2,2)'
%   specifies a 2D (tensor) transform with the S+P (2,2) wavelet.
%   2D transforms require that X is either MxN or MxNxP where M and N
%   are divisible by 2^L.
%
%  说明sym： WAVELET(W,L,X,EXT) specifies boundary handling EXT.  Choices are
%     'sym'      Symmetric extension (same as 'wsws')
%     'asym'     Antisymmetric extension, whole-point antisymmetry
%     'zpd'      Zero-padding
%     'per'      Periodic extension
%     'sp0'      Constant extrapolation
%
%   Various symmetric extensions are supported:
%     'wsws'     Whole-point symmetry (WS) on both boundaries
%     'hshs'     Half-point symmetry (HS) on both boundaries
%     'wshs'     WS left boundary, HS right boundary
%     'hsws'     HS left boundary, WS right boundary
%
%   Antisymmetric boundary handling is used by default, EXT = 'asym'.
%
%   WAVELET(...,DIM) operates along dimension DIM.
%
%   [H1,G1,H2,G2] = WAVELET(W,'filters') returns the filters
%   associated with wavelet transform W.  Each filter is represented
%   by a cell array where the first cell contains an array of
%   coefficients and the second cell contains a scalar of the leading
%   Z-power.
%
%   [X,PHI1] = WAVELET(W,'phi1') returns an approximation of the
%   scaling function associated with wavelet transform W.
%   [X,PHI1] = WAVELET(W,'phi1',N) approximates the scaling function
%   with resolution 2^-N.  Similarly,
%   [X,PSI1] = WAVELET(W,'psi1',...),
%   [X,PHI2] = WAVELET(W,'phi2',...),
%   and [X,PSI2] = WAVELET(W,'psi2',...) return approximations of the
%   wavelet function, dual scaling function, and dual wavelet function.
%
%   Wavelet transforms are implemented using the lifting scheme [4].
%   For general background on wavelets, see for example [6].
%
%
%   Examples:
%   % Display information about the S+P (4,4) wavelet
%   wavelet('S+P (4,4)');
%
%   % Plot a wavelet decomposition
%   t = linspace(0,1,256);
%   X = exp(-t) + sqrt(t - 0.3).*(t > 0.3) - 0.2*(t > 0.6);
%   wavelet('RSpline 3.1',3,X);        % Plot the decomposition of X
%
%   % Sym4 with periodic boundaries
%   Y = wavelet('Sym4',5,X,'per');    % Forward transform with 5 stages
%   R = wavelet('Sym4',-5,Y,'per');   % Invert 5 stages
%
%   % 2D transform on an image
%   t = linspace(-1,1,128); [x,y] = meshgrid(t,t);
%   X = ((x+1).*(x-1) - (y+1).*(y-1)) + real(sqrt(0.4 - x.^2 - y.^2));
%   Y = wavelet('2D CDF 9/7',2,X);    % 2D wavelet transform
%   R = wavelet('2D CDF 9/7',-2,Y);   % Recover X from Y
%   imagesc(abs(Y).^0.2); colormap(gray); axis image;
%
%   % Plot the Daubechies 2 scaling function
%   [x,phi] = wavelet('D2','phi');
%   plot(x,phi);

if nargin < 1, error('Not enough input arguments.'); end
if ~ischar(WaveletName), error('Invalid wavelet name.'); end

% Get a lifting scheme sequence for the specified wavelet
Flag1D = isempty(findstr(lower(WaveletName),'2d'));
[Seq,ScaleS,ScaleD,Family] = getwavelet(WaveletName);

if isempty(Seq)
   error(['Unknown wavelet, ''',WaveletName,'''.']);
end

if nargin < 2, Level = ''; end
if ischar(Level)
   [h1,g1] = seq2hg(Seq,ScaleS,ScaleD,0);
   [h2,g2] = seq2hg(Seq,ScaleS,ScaleD,1);

   if strcmpi(Level,'filters')
      varargout = {h1,g1,h2,g2};
   else
      if nargin < 3, X = 6; end

      switch lower(Level)
      case {'phi1','phi'}
         [x1,phi] = cascade(h1,g1,pow2(-X));
         varargout = {x1,phi};
      case {'psi1','psi'}
         [x1,phi,x2,psi] = cascade(h1,g1,pow2(-X));
         varargout = {x2,psi};
      case 'phi2'
         [x1,phi] = cascade(h2,g2,pow2(-X));
         varargout = {x1,phi};
      case 'psi2'
         [x1,phi,x2,psi] = cascade(h2,g2,pow2(-X));
         varargout = {x2,psi};
      case ''
         fprintf('\n%s wavelet ''%s'' ',Family,WaveletName);

         if all(abs([norm(h1{1}),norm(h2{1})] - 1) < 1e-11)
            fprintf('(orthogonal)\n');
         else
            fprintf('(biorthogonal)\n');
         end
         
         fprintf('Vanishing moments: %d analysis, %d reconstruction\n',...
            numvanish(g1{1}),numvanish(g2{1}));
         fprintf('Filter lengths: %d/%d-tap\n',...
            length(h1{1}),length(g1{1}));         
         fprintf('Implementation lifting steps: %d\n\n',...
            size(Seq,1)-all([Seq{1,:}] == 0));
         
         fprintf('h1(z) = %s\n',filterstr(h1,ScaleS));
         fprintf('g1(z) = %s\n',filterstr(g1,ScaleD));
         fprintf('h2(z) = %s\n',filterstr(h2,1/ScaleS));
         fprintf('g2(z) = %s\n\n',filterstr(g2,1/ScaleD));

         [x1,phi,x2,psi] = cascade(h1,g1,pow2(-X));
         subplot(2,2,1);
         plot(x1,phi,'b-');
         if diff(x1([1,end])) > 0, xlim(x1([1,end])); end
         title('\phi_1');
         subplot(2,2,3);
         plot(x2,psi,'b-');
         if diff(x2([1,end])) > 0, xlim(x2([1,end])); end
         title('\psi_1');
         [x1,phi,x2,psi] = cascade(h2,g2,pow2(-X));
         subplot(2,2,2);
         plot(x1,phi,'b-');
         if diff(x1([1,end])) > 0, xlim(x1([1,end])); end
         title('\phi_2');
         subplot(2,2,4);
         plot(x2,psi,'b-');
         if diff(x2([1,end])) > 0, xlim(x2([1,end])); end
         title('\psi_2');
         set(gcf,'NextPlot','replacechildren');
      otherwise
         error(['Invalid parameter, ''',Level,'''.']);
      end
   end

   return;
elseif nargin < 5
   % Use antisymmetric extension by default
   if nargin < 4
      if nargin < 3, error('Not enough input arguments.'); end

      Ext = 'asym';
   end

   Dim = min(find(size(X) ~= 1));
   if isempty(Dim), Dim = 1; end
end

if any(size(Level) ~= 1), error('Invalid decomposition level.'); end

NumStages = size(Seq,1);
EvenStages = ~rem(NumStages,2);

if Flag1D   % 1D Transfrom
   %%% Convert N-D array to a 2-D array with dimension Dim along the columns %%%
   XSize = size(X);    % Save original dimensions
   N = XSize(Dim);
   M = prod(XSize)/N;
   Perm = [Dim:max(length(XSize),Dim),1:Dim-1];
   X = double(reshape(permute(X,Perm),N,M));

   if M == 1 & nargout == 0 & Level > 0
      % Create a figure of the wavelet decomposition
      set(gcf,'NextPlot','replace');
      subplot(Level+2,1,1);
      plot(X);
      title('Wavelet Decomposition');
      axis tight; axis off;

      X = feval(mfilename,WaveletName,Level,X,Ext,1);

      for i = 1:Level
         N2 = N;
         N = 0.5*N;
         subplot(Level+2,1,i+1);
         a = max(abs(X(N+1:N2)))*1.1;
         plot(N+1:N2,X(N+1:N2),'b-');
         ylabel(['d',sprintf('_%c',num2str(i))]);
         axis([N+1,N2,-a,a]);
      end

      subplot(Level+2,1,Level+2);
      plot(X(1:N),'-');
      xlabel('Coefficient Index');
      ylabel('s_1');
      axis tight;
      set(gcf,'NextPlot','replacechildren');
      varargout = {X};
      return;
   end

   if rem(N,pow2(abs(Level))), error('Signal length must be divisible by 2^L.'); end
   if N < pow2(abs(Level)), error('Signal length too small for transform level.'); end

   if Level >= 0           % Forward transform
      for i = 1:Level
         Xo = X(2:2:N,:);
         Xe = X(1:2:N,:) + xfir(Seq{1,1},Seq{1,2},Xo,Ext);

         for k = 3:2:NumStages
            Xo = Xo + xfir(Seq{k-1,1},Seq{k-1,2},Xe,Ext);
            Xe = Xe + xfir(Seq{k,1},Seq{k,2},Xo,Ext);
         end

         if EvenStages
            Xo = Xo + xfir(Seq{NumStages,1},Seq{NumStages,2},Xe,Ext);
         end

         X(1:N,:) = [Xe*ScaleS; Xo*ScaleD];
         N = 0.5*N;
      end
   else                     % Inverse transform
      N = N * pow2(Level);

      for i = 1:-Level
         N2 = 2*N;
         Xe = X(1:N,:)/ScaleS;
         Xo = X(N+1:N2,:)/ScaleD;

         if EvenStages
            Xo = Xo - xfir(Seq{NumStages,1},Seq{NumStages,2},Xe,Ext);
         end

         for k = NumStages - EvenStages:-2:3
            Xe = Xe - xfir(Seq{k,1},Seq{k,2},Xo,Ext);
            Xo = Xo - xfir(Seq{k-1,1},Seq{k-1,2},Xe,Ext);
         end

         X([1:2:N2,2:2:N2],:) = [Xe - xfir(Seq{1,1},Seq{1,2},Xo,Ext); Xo];
         N = N2;
      end
   end

   X = ipermute(reshape(X,XSize(Perm)),Perm);   % Restore original array dimensions
else        % 2D Transfrom
   N = size(X);

   if length(N) > 3 | any(rem(N([1,2]),pow2(abs(Level))))
      error('Input size must be either MxN or MxNxP where M and N are divisible by 2^L.');
   end

   if Level >= 0   % 2D Forward transform
      for i = 1:Level
         Xo = X(2:2:N(1),1:N(2),:);
         Xe = X(1:2:N(1),1:N(2),:) + xfir(Seq{1,1},Seq{1,2},Xo,Ext);

         for k = 3:2:NumStages
            Xo = Xo + xfir(Seq{k-1,1},Seq{k-1,2},Xe,Ext);
            Xe = Xe + xfir(Seq{k,1},Seq{k,2},Xo,Ext);
         end

         if EvenStages
            Xo = Xo + xfir(Seq{NumStages,1},Seq{NumStages,2},Xe,Ext);
         end

         X(1:N(1),1:N(2),:) = [Xe*ScaleS; Xo*ScaleD];
         
         Xo = permute(X(1:N(1),2:2:N(2),:),[2,1,3]);
         Xe = permute(X(1:N(1),1:2:N(2),:),[2,1,3]) ...
            + xfir(Seq{1,1},Seq{1,2},Xo,Ext);

         for k = 3:2:NumStages
            Xo = Xo + xfir(Seq{k-1,1},Seq{k-1,2},Xe,Ext);
            Xe = Xe + xfir(Seq{k,1},Seq{k,2},Xo,Ext);
         end

         if EvenStages
            Xo = Xo + xfir(Seq{NumStages,1},Seq{NumStages,2},Xe,Ext);
         end
         
         X(1:N(1),1:N(2),:) = [permute(Xe,[2,1,3])*ScaleS,...
               permute(Xo,[2,1,3])*ScaleD];
         N = 0.5*N;
      end
   else           % 2D Inverse transform
      N = N*pow2(Level);

      for i = 1:-Level
         N2 = 2*N;
         Xe = permute(X(1:N2(1),1:N(2),:),[2,1,3])/ScaleS;
         Xo = permute(X(1:N2(1),N(2)+1:N2(2),:),[2,1,3])/ScaleD;

         if EvenStages
            Xo = Xo - xfir(Seq{NumStages,1},Seq{NumStages,2},Xe,Ext);
         end

         for k = NumStages - EvenStages:-2:3
            Xe = Xe - xfir(Seq{k,1},Seq{k,2},Xo,Ext);
            Xo = Xo - xfir(Seq{k-1,1},Seq{k-1,2},Xe,Ext);
         end
         
         X(1:N2(1),[1:2:N2(2),2:2:N2(2)],:) = ...
            [permute(Xe - xfir(Seq{1,1},Seq{1,2},Xo,Ext),[2,1,3]), ...
               permute(Xo,[2,1,3])];
         
         Xe = X(1:N(1),1:N2(2),:)/ScaleS;
         Xo = X(N(1)+1:N2(1),1:N2(2),:)/ScaleD;

         if EvenStages
            Xo = Xo - xfir(Seq{NumStages,1},Seq{NumStages,2},Xe,Ext);
         end

         for k = NumStages - EvenStages:-2:3
            Xe = Xe - xfir(Seq{k,1},Seq{k,2},Xo,Ext);
            Xo = Xo - xfir(Seq{k-1,1},Seq{k-1,2},Xe,Ext);
         end
         
         X([1:2:N2(1),2:2:N2(1)],1:N2(2),:) = ...
            [Xe - xfir(Seq{1,1},Seq{1,2},Xo,Ext); Xo];
         N = N2;
      end
   end
end

varargout{1} = X;
return;

