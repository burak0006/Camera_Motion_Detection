%% Showing outlier blocks

function yCurr = segshow(yCurr, iMap, coorX, coorY, blkSize);

for i=1:length(coorX(:,1))
    for j=1:length(coorX(1,:))
        if(iMap(i,j)==0)
            R0 = coorY(i,j) - (blkSize/2-1);
            R1 = coorY(i,j) + (blkSize/2);
            C0 = coorX(i,j) - (blkSize/2-1);
            C1 = coorX(i,j) + (blkSize/2);
            
            %rgb = ind2rgb(yCurr(R0:R1,C0:C1), jet(256));
            yCurr(R0:R1,C0:C1)=10;          
        end
    end
end
imshow(yCurr/255);
