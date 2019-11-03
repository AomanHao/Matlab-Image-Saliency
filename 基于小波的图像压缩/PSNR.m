function r = PSNR(in, est)
% To find PSNR between input (in) and estimate (est) in decibels (dB).
%

error = in - est;

[m,n] = size(in);

r = 10*log10((m*n*(max(in(:)))/sum(error(:).^2)));

% r = 10 * log10((var(in(:), 1)) / mean(error(:).^2));