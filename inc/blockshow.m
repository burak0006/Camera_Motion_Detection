function blockshow(yCurr, iMap, coorX, coorY, blkSize);

imshow(yCurr/255);

hold on;
for i=1:length(coorX(:,1))
    for j=1:length(coorX(1,:))
        if(iMap(i,j)==0)
            
            R0 = coorY(i,j) - (blkSize/2-1);
            R1 = coorY(i,j) + (blkSize/2);
            C0 = coorX(i,j) - (blkSize/2-1);
            C1 = coorX(i,j) + (blkSize/2);
                        
            plot([C0 C1], [R0 R0], '-y');
            plot([C0 C1], [R1 R1], '-y');
            plot([C0 C0], [R0 R1], '-y');
            plot([C1 C1], [R0 R1], '-y');
            
        end
    end
    
end
hold off;

