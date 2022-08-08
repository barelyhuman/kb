watch: 
	npx -y serve ./dist & 
	ls hooks/* pages/* public/* | entr -cr alvu

w: watch
