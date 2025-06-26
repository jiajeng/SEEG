function DatTab = edat2table(file)
    Dat = readcell(file);
    Sidx = find(cellfun(@(x) any(x=="*** LogFrame Start ***"),Dat(:,1)));
    Eidx = find(cellfun(@(x) any(x=="*** LogFrame End ***"),Dat(:,1))); 
    
    DatTab = table();
    for i = 1:length(Sidx)
        LF = Dat(Sidx(i)+1:Eidx(i)-1,:);
        for j = 1:size(LF,1)
            DatTab.(LF{j,1})(i) = LF(j,2);
        end
    end
    DatTab(cellfun(@isempty, DatTab.Procedure),:) = [];
end