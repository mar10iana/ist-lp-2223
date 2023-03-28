c1(X,Y):- d(X), s(Y, X).
c2(X,Y):- d(X),!, s(Y, X).
c3(X,Y):- d(X), \+ s(Y, X).
d(r).
d(2).
d(3).
s(2,r).
s(r,r).
s(2,2).
s(t,2).
s(t,t).