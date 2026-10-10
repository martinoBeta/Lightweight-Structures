function [pb,ub]=buckle(Ks,Ksigmas,nnode,node_z)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Solve beam buckling equation
    % File name: buckle.m
    % 
    % Ks		Structural stiffness matrix
    % Ksigmas	Structural initial stiffness matrix
    % nnode		Number of nodes
    % node_z	Nodal x-coordinates
    %
    % pb		Matrix with eigenvalues (load factors) in diagonal
    % ub		Corresponding matrix of eigenvectors (buckling modes)
    % 	(Column i of ub shows the buckling mode for buckling load (i,i) in pb)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% Calculate eigenvalues and eigenvectors
    [ub,pb] = eig(Ks,-Ksigmas);
    bucklingLoads = diag(pb);

    %% Split bending and twist modes into separate vectors
    posBending = [];
    posTorsion = [];
    for i = 1:(nnode-1)*3                 
        if any(abs(ub(3:3:end,i)) > 1e-10)    % tolerance for 0, checks every third option for fi ~= 0
            posTorsion = [posTorsion, i];
        else
            posBending = [posBending, i];
        end
    end

    % checks if the number of eigenvalues for torsion is the expected number
    if length(posTorsion) == (nnode - 1)
    else
        error("The number of torsion eigenvectors found doesn't match");
    end

    ubTorsion = ub(:,posTorsion);
    ubBending = ub(:,posBending);


    %% Normalize deflections, rotations and twist for plotting purposes (without risking to mix up signs or divide by zero)
    % Initial conditions
    w0 = [0,0,0];        % w,theta,fi
    
    
    fiTorsion = zeros(nnode,length(posTorsion)); 

    for i = 1:length(posTorsion)
        fiTorsion(1:end,i) = [w0(3); ubTorsion(3:3:end,i)];
        fiNorm = norm(fiTorsion(:,i));
        if fiNorm ~= 0
            fiTorsion(:,i) = fiTorsion(:,i) / fiNorm;
        end
    end

    wBending = zeros(nnode,length(posBending));
    thetaBending = zeros(nnode,length(posBending)); 

    for i = 1:length(posBending)
        wBending(1:end,i) = [w0(1); ubBending(1:3:end,i)];
        wNorm = norm(wBending(:,i));
        if  wNorm ~= 0
            wBending(:,i) = wBending(:,i) / wNorm;
        end

        thetaBending(1:end,i) = [w0(2); ubBending(2:3:end,i)];
        thetaNorm = norm(thetaBending(:,i));
        if thetaNorm ~= 0
            thetaBending(:,i) = thetaBending(:,i) / thetaNorm;
        end
    end

    %% Plot buckling modes

    % Torsion
    nPlotT = 2;      % number of maximum plotted buckling modes
    nPlotT = min(nPlotT,length(posTorsion));
    figure("name","Torsion")            % twist (fi)
    title("Torsion twist \phi")
    hold on
    for i = 1:nPlotT
        plot(node_z,fiTorsion(:,i))
        plot(node_z,fiTorsion(:,i),"o")
    end
    xlabel("Node position [m]")
    ylabel("Twist [-]")
    legend("1")
    

    % Bending 
    nPlotB = 2;      % number of maximum plotted buckling modes
    nPlotB = min(nPlotB,length(posBending));

    figure("name","Bending Displacement") 
    title("Bending displacement w")        
    hold on
    for i = 1:nPlotB
        plot(node_z,wBending(:,i))
        plot(node_z,wBending(:,i),"o")
    end
    xlabel("Node position [m]")
    ylabel("Displacement [-]")
    legend("1")



    figure("name","Bending Rotation") 
    title("Bending rotation \theta")        
    hold on
    for i = 1:nPlotB
        plot(node_z,thetaBending(:,i))
        plot(node_z,thetaBending(:,i),"o")
    end
    xlabel("Node position [m]")
    ylabel("Rotation [-]")
    legend("1")


    %% Present the buckling loads
    numberLoads = min(2,length(posBending));

    fprintf("\nDisplaying %.f/%.f buckling loads for bending:\n",numberLoads,length(posBending))
    for i = 1:numberLoads
        fprintf("m = %2.f , F = %5.1f [N]\n",i,bucklingLoads(posBending(i)));
    end

    fprintf("\nDisplaying buckling load for torsion: \n");
    fprintf("F = %1.f [N]\n",bucklingLoads(posTorsion(1)));

end