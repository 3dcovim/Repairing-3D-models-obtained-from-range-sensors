function f = funcion_objetivo2(x)

global p;
global p_ext;

f=0;
f1=0;
f2=0;
for k= 1:length(p)-1;
    %f = f + dot(x(:,1)',p(k, :)) * dot(x(:,2)',p(k+1, :)) - dot(x(:,1)',p(k+1, :)) * dot(x(:,2)',p(k, :));
    %f = f + (x(:,1)'*p(k, :)') * (x(:,2)'*p(k+1, :)') -...
    %    (x(:,1)'*p(k+1, :)') * (x(:,2)'*p(k, :)');
    f1 = f1 + ((x(:,1)/norm(x(:,1)))'*p(k, :)') * ((x(:,2)/norm(x(:,2)))'*p(k+1, :)') -...
       ((x(:,1)/norm(x(:,1)))'*p(k+1, :)') * ((x(:,2)/norm(x(:,2)))'*p(k, :)');
end
%f=-f;

for k= 1:length(p_ext)-1;
    %f = f + dot(x(:,1)',p(k, :)) * dot(x(:,2)',p(k+1, :)) - dot(x(:,1)',p(k+1, :)) * dot(x(:,2)',p(k, :));
    %f = f + (x(:,1)'*p(k, :)') * (x(:,2)'*p(k+1, :)') -...
    %    (x(:,1)'*p(k+1, :)') * (x(:,2)'*p(k, :)');
    f2 = f2 + ((x(:,1)/norm(x(:,1)))'*p_ext(k, :)') * ((x(:,2)/norm(x(:,2)))'*p_ext(k+1, :)') -...
       ((x(:,1)/norm(x(:,1)))'*p_ext(k+1, :)') * ((x(:,2)/norm(x(:,2)))'*p_ext(k, :)');
end

f=f2-f1;