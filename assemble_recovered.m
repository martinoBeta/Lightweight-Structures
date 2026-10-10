function [K,Q,M,Ksigma]=assemble(le,EI,GJ,I0,A,J0,q,qt,S,T,m,P,ndof,nelem);

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

for i=1:nelem
    K(i:i+1,i:i+1)=K(i:i+1,i:i+1) + K_e;
    Q(i:i+1,i:i+1)=Q(i:i+1,i:i+1) + Q_e;
    Ksigma(i:i+1,i:i+1)=Ksigma(i:i+1,i:i+1) +Ksigma_e;
    M(i:i+1,i:i+1)=M(i:i+1,i:i+1) + M_e;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add concentrated loads
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Q_c=zeros(ndof,1);
Q_c(nodf -2:nodf)=[S,0,T];
Q=Q+Q_c;

