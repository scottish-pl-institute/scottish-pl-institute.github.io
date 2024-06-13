all:
	stack build
	stack exec site rebuild

rebuild:
	stack exec site rebuild

rebuildw:
	stack exec site rebuild
	stack exec site watch

watch:
	stack exec site watch
