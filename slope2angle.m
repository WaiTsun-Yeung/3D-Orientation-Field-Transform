function angles = slope2angle(yr,x,operation)
%Only for @atan
% slope = [yr;x];
zero2 = x==0;
% angles = zeros(size(yr),'single');
angles = operation(yr./x);
n = yr<0;
angles(n&zero2) = -pi/2;
angles((~n)&zero2) = pi/2;
angles(yr==0&zero2) = NaN;
% for ii = 1:length(yr)
%     if sum(zero(:,ii))==2
%         angles(ii) = NaN;
%     elseif zero(2,ii)
%         if yr(ii)<0
%             angles(ii) = -pi/2;
%         else
%             angles(ii) = pi/2;
%         end
%     else
%         angles(ii) = operation(slope(1,ii)./slope(2,ii));
%     end
% end