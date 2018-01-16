function TopoFSO
%filename = '/home/minhhien/Documents/Result_master/DataInput/inputnodes_k3M8.txt';
filename = '/home/minhhien/Documents/Result_master/DataInput/inputnodes_k3M9.txt';
%filename = '/home/minhhien/Documents/Result_master/DataInput/inputnodes_k3M10.txt';
%filename = '/home/minhhien/Documents/Result_master/DataInput/inputnodes_k3M11.txt';
%filename = '/home/minhhien/Documents/Result_master/DataInput/inputnodes_k3M12.txt';
run_one_topo(filename);
end

function run_one_topo(filename)
format shortg
timecurrent = clock;
disp('Thoi gian bat dau chay chuong trinh la: ');disp(timecurrent);
% open the file
fid = fopen(filename);
% read the file headers, find M (number of node)
k = fscanf(fid,'%*s %*s %*s %*s %f',1);
M = fscanf(fid,'%*s %*s %*s %d',1);
fscanf(fid,'%*s %*s %*s %*s %*s %*s %*s',7); % bo qua 7 chuoi tiep theo
% read each set of node
Node = fscanf(fid,'%f',[3,M]);      % Node: chua gia tri cua cac node
N=Node';                            % nghich dao matrix Node
Threshold_BER = fscanf(fid,'%*s %*s %f',1);
fscanf(fid,'%*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s',11);
F = fscanf(fid,'%d',[3,Inf]);    % source_index,dest_index and bandwidth
matrixD = F';      % matixD la ma  tran yeu cau
matrixD_output=matrixD;
D = size(matrixD,1);  % so luong yeu cau dc sinh ra            
                
fclose(fid);
timeinput = etime(clock, timecurrent);
disp('Thoi gian doc file input la: ');disp(timeinput)
timeweitghtbegin = clock;
disp('Nguong BER la: ');disp(Threshold_BER)
disp('He so k la: ');disp(k)
%%
%c=0.25;
Lmax=1600;
Bwmax=1000;
L = zeros(M); % L la matrix chua khoang cach giua cac node
W = zeros(M); % W la matrix chua weight giua cac node
Tw = zeros(M); % Tw la matrix chua weight da dc su dung
BW = Bwmax+zeros(M);
BER = zeros(M);
%tongthietbi=0;
tongW=0;
Inpath{1,D}=[];
distK=zeros(M);
 %-------------------------------
    function  Addpath(path)
        for q=1:(numel(path)-1)
                % them vao topo
                %disp('Nhung edge khong t/m bandwidth yeu cau thi trong so w cua canh do duoc gan = inf')
                %if path(q) > path(q+1) 
                    Tw(path(q),path(q+1))= Tw(path(q),path(q+1))+1;
                    % giam bang thong
                    BW(path(q),path(q+1))=BW(path(q),path(q+1))-bw(m);                  
                     % giam trong so cua canh da dung
                     if ( BW(path(q),path(q+1))>0)
                        W(path(q),path(q+1)) = 1-BW(path(q),path(q+1))/Bwmax;
                     else if (BW(path(q),path(q+1))==0)
                            W(path(q),path(q+1))=inf;
                         else
                             disp(['Error in counting bandwidth']);
                             return;
                         end
                     end
               
                   %Giam trong so ca chieu nguoc lai.
                    if ( BW(path(q+1),path(q))>0)
                        W(path(q+1),path(q))=1 - BW(path(q+1),path(q))/Bwmax;
                    end  
        end
    end
 %-------------------------------
    function Bandwidth(b) % kiem tra bang thong con du, loai cac canh het bang thong khoi G
        for j=1:M
            for i=1:M
                if i == j
                    G(i,j) = 0;
                end
                if BW(i,j)<bw
                    %disp('Nhung edge khong t/m bandwidth yeu cau thi trong so w cua canh do duoc gan = inf');%BW-bw
                    %disp([num2str(i), ',' ,num2str(j)]);
                    G(i,j)=inf;
                end
             end
        end
               
    end
 %-------------------------------

%% %-------------------------------
disp('Tong so node la: ');disp(M)
for i=1:M
    x=N(1:M,1);
    y=N(1:M,2);
    z=N(1:M,3);
end
disp('Toa do cua cac node la: ')
for i=1:M
    V=[x(i) y(i) z(i)];
    disp(['Toa do cua node thu',' ',num2str(i),' ','la',' ','v',num2str(i),'=',' ','(',num2str(V),')'])
end
fprintf('\n')


%% tinh khoang cach L giua cac node, gan trong so cho cac canh W(i,j)=-log10(1-BER(i,j));
L_mean =0; % khoang cach trung binh giua cac nut 
L_total =0;
L_num =0;
L_feasible_num=0; % number of link under maximum distance 

disp('Khoang cach giua cac node la: ')
for j=1:M
    for i=(j+1):M           
        L(i,j)=sqrt((x(i)-x(j))^(2)+(y(i)-y(j))^(2)+(z(i)-z(j))^(2));   % L la matrix(i,j) chua khoang cach giua cac node
        if L(i,j)>Lmax
           W(i,j)=inf;
           BER(i,j)=1;
        elseif L(i,j)<750 && L(i,j)>0
           BER(i,j)=BER_FSO(750);
           W(i,j)=1;
           L_feasible_num=L_feasible_num +1;
        else
            BER(i,j)= BER_FSO(L(i,j));      % B la matrix(i,j) chua weight(BER) giua cac node
            W(i,j)=1;
            L_feasible_num = L_feasible_num +1;
        end
        BER(j,i)=BER(i,j);
        W(j,i) = W(i,j);
       
        %disp(['khoang cach giua node ',num2str(i),' ','va',' ',num2str(j),' ','la',' ','L','(',num2str(i),',',num2str(j),')','=',num2str(L(i,j))])                     
        disp(['Weight giua node (',num2str(i),',',num2str(j),') ','=',' ','W','(',num2str(i),',',num2str(j),')','=',num2str(W(i,j))])
        L_total = L_total + L(i,j);
        L_num = L_num +1;  
     end
end


%--------------------------
disp(['Ma tran D ban dau ']);
disp(matrixD);

% Sap xep
count_temp =1;
count_inf = 0;
    while count_temp <= D - count_inf
        if isinf(W(matrixD(count_temp,1),matrixD(count_temp,2)))
            %disp(strcat('test',num2str(count_temp)));
            temp = matrixD(count_temp,:);
            for j=count_temp:D-1
                matrixD(j,:) = matrixD(j+1,:);
            end
            matrixD(D,:) = temp;
            count_temp = count_temp - 1;
            count_inf = count_inf + 1;
        end
        count_temp = count_temp + 1;
    end
     for i=D:-1:D-count_inf+2
        for j=D-count_inf+1:i-1
            if matrixD(j,3) < matrixD(j+1,3)
               temp=matrixD(j,:);
                matrixD(j,:)=matrixD(j+1,:);
                matrixD(j+1,:)=temp;
            end
        end
    end

    
s = matrixD(1:D,1);   % source_index
t = matrixD(1:D,2);   % dest_index
bw = matrixD(1:D,3);  % bandwidth don vi Mbps
sum_bw= sum(matrixD(1:D,3));
    
v = [s t bw];
disp('Ma tran yeu cau la D sau sap xep= ');disp(v)
disp('Tong so yeu cau la: ');disp(D)
%---------------------------
%uoc luong so link can su dung voi ma tran D yeu cau 

estimated_total_bw =0;
for m=1:D
    if (s(m)>t(m))
        estimated_total_bw = estimated_total_bw + bw(m) * ceil(L(s(m),t(m))/Lmax);
    else 
        estimated_total_bw = estimated_total_bw + bw(m) * ceil(L(t(m),s(m))/Lmax);
    end
end

L_mean= L_total/L_num;
fprintf('\n');
timeweight = etime(clock, timeweitghtbegin);
disp('Thoi gian tinh weight la: ');disp(timeweight);
fprintf('\n');


%% Thuat toan

% [a,b,w]=find(W);   % w la array chua cac phan tu hang u cot v cua matrix W (u <=> i;v <=> j)
% DG=sparse(a,b,w);   % sparse la matrix thua t/m DG(a(k),b(k)) = w(k) 
% UG=tril(DG,-1);     % trill la lay phan tam giac thap hon cua DG bo qua duong cheo
                        % UG chua gia tri trong so -log10            


f_all = fopen('/home/minhhien/Documents/Result_master/OutputTopoSynthesis.txt','a');
rho = M/(k*k);
%net_utility = sum_bw/(rho* 3.14 * Lmax/1000*Lmax/1000*Lmax/L_mean *M * Bwmax) 
net_u = estimated_total_bw/(Bwmax*L_feasible_num*2);
fprintf(f_all,' \t k\t%f \t M\t%d\t rho\t%f\t D\t%d \t L_mean\t%f \t L_feasible\t%d \t sum_bw\t%d \t net_u\t%f\t' ,k, M,rho, D, L_mean, L_feasible_num, sum_bw, net_u);
          
%W_without_coff = W_without_coff + transpose(W_without_coff);
%BER = BER + transpose(BER);
for m=1:D    
    
    G=W;
    Bandwidth(bw(m)); %Bo cac canh ko du bang thong tren G
   % G=G+ transpose(G);
    %disp(G);
    %[dist,path] = graphshortestpath(sparse(G),s(m),t(m),'Directed',false, 'Method', 'Dijkstra'); %undirected graph
    [~,path,status] = dijkstra_modified_BER(sparse(G),s(m),t(m),BER,Threshold_BER, BW); %undirected graph
    if (status ==1)
        disp(['Path giua node',' ',num2str(s(m)),' ','va',' ',num2str(t(m)),' ','la',': ']);disp(path);
        %disp(['do dai duong di ', num2str(dist)]);
    else
        disp(['No feasible path is found. Bai toan vo nghiem ']);
        fprintf(f_all, 'No feasible solution\n');
      save ('/home/minhhien/Documents/MasterProject/Master_Project/HeuristicProg/Code_Matlab/varicurrent','Node','BER','M','s','k','t','Tw','bw','D','Inpath','distK','W','timecurrent','timeinput','timeweight','matrixD','BW','N','Bwmax','matrixD_output') % luu cac bien 'Node','BER' vao trong file ''

        OutputTopoDat
        OutputBER
        return;
    end;
    
    Inpath{m}=path;
    %path thoa man dieu kien 
    Addpath(path) % Add vao topo
    
end 

%WW = W_without_coff;
[a,b,TT] = find(Tw);    
disp('Cac egde da su dung la: ');disp(sparse(Tw));
tongBER=0;
count_duplicate =0;
for i=1: numel(a)-1
   for j= i+1:numel(a)
    if  a(i) == b(j) && b(i) == a(j)
        count_duplicate = count_duplicate+1;
    end
   end
end
tonglink = numel(a)-count_duplicate;
%ve topo mang 
for i=1 : numel(a)
    tongBER = tongBER + BER(a(i),b(i)); % tong BER tren toan bo Topo
    matrixPlot=zeros(2,3);
    matrixPlot(1,:)=N(a(i),:);
    matrixPlot(2,:)=N(b(i),:);
    X=matrixPlot(1:2,1);
    Y=matrixPlot(1:2,2);
    Z=matrixPlot(1:2,3);
    
    plot3(X,Y,Z,'-o');
    %saveas(gcf,'Demo','jpg');
   
    xlabel('x-axis(m)');ylabel('y-axis(m)');zlabel('z-axis(m)');
    grid on;
    hold on;
end


for j=1:M
    for i=(j+1):M
        if BW(i,j)==1000
            BW(i,j)=0;
            BW(j,i)=0;
        end
    end
end
%BW

BBBW = sparse(BW);
BWEND=tril(BBBW,-1);
%tonglink=numel(TT);

L_average_num=0;
for i=1:m
    L_average_num = L_average_num+ numel(Inpath{i})-1;
end
L_average_num =L_average_num/m;
%tongBER=sum(distK);
%BWW
disp('Bandwidth con lai cua cac edge su dung la: ');disp(BWEND);
disp('Tong so BER tren Topo la: ');disp(tongBER)
%disp('Tong so Weight(do dai duong di) tren Topo la: ');disp(tongW)
disp('Tong so link su dung cho Topo la: ');disp(tonglink)
disp('Thoi gian ket thuc chuong trinh la: ');disp(timecurrent)
timeTopo = etime(clock, timecurrent);
disp('Thoi gian chay het chuong trinh la: ');disp(timeTopo)
save ('/home/minhhien/Documents/MasterProject/Master_Project/HeuristicProg/Code_Matlab/varicurrent','Node','tongBER','BER','M','s','k','t','Tw','bw','D','Inpath','distK','W','tonglink','timecurrent','timeinput','timeweight','timeTopo','matrixD','BW','N','Bwmax','matrixD_output') % luu cac bien 'Node','BER' vao trong file 'varicurrent.mat'
efficiency = tonglink/L_feasible_num;
fprintf(f_all,'\t timeTopo\t%-0.4f \t Tong link \t%d \tEfficiency \t %f \t Avg links/path \t%f \t Tong BER \t%d\n', timeTopo, tonglink, efficiency, L_average_num, tongBER);
fclose(f_all);

OutputTopo
OutputTopoDat
OutputBER
%clearvars
end

 
