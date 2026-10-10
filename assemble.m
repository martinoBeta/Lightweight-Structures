function [K,Q,M,Ksigma]=assemble(le,EI,GJ,I0,A,J0,q,qt,S,T,m,P,ndof,nelem)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Assemble system stiffness matrix, load vector, mass matrix (not necessary)
    % and initial stress matrix
    % File name: assemble.m
    %
    % K		System stiffness matrix
    % Q		System load vector
    % M		System mass matrix
    % Ksigma       System initial stress matrix
    %
    % le		element length [m]
    % EI		element bending stiffness [Nm2]
    % GJ		element torsional stiffness [Nm2]
    % I0		element polar moment of inertia [m4]
    % A		element cross-section area [m2]
    % J0		element mass moment of inertia [kgm]
    % q		element transverse pressure load [N/m]
    % qt		element torsion pressure load [Nm/m]
    % S		transverse point load [N]
    % T		local torque [Nm]
    % m		element mass per unit length [kg/m]
    % P		applied buckling load [N], positive if tensile
    % ndof		number of degrees of freedom
    % nelem		number of elements
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    K=zeros(ndof);
    Q=zeros(ndof,1);
    M=zeros(ndof);
    Ksigma=zeros(ndof);

    K_e=elk(le,EI,GJ);
    Q_e=elq(le,q,qt);
    Ksigma_e=elksigma(le,P,I0,A);
    M_e=elm(le,m,J0);

    kk = 0;

    for i=1:nelem  
        K(kk+1:kk+6,kk+1:kk+6)=K(kk+1:kk+6,kk+1:kk+6) + K_e;
        Q(kk+1:kk+6)=Q(kk+1:kk+6) + Q_e;
        Ksigma(kk+1:kk+6,kk+1:kk+6)=Ksigma(kk+1:kk+6,kk+1:kk+6) +Ksigma_e;
        M(kk+1:kk+6,kk+1:kk+6)=M(kk+1:kk+6,kk+1:kk+6) + M_e;
        kk = kk +3;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Add concentrated loads
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Q_c=zeros(ndof,1);
    Q_c(ndof -2:ndof)=[S,0,T];
    Q=Q+Q_c;
end
