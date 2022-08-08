watch: 
	npx -y serve ./dist & 
	ls hooks/* pages/* | entr -cr alvu

w: watch
