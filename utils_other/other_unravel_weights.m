weights = [];
node1 = {};
node2 = {};

for ii = 1:size(random_ordered,1)
    for jj = 1:size(random_ordered,2)
        node1 = [node1; num2str(ii)];
        node2 = [node2; num2str(jj)];
        weights = [weights; random_unordered(ii,jj)];
    end
end