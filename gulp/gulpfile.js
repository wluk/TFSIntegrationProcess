var gulp = require('gulp'),
    path = require('path'),
    folders = require('gulp-folders'),
    pathToFolder = 'path/to/folder';
 
gulp.task('task', folders(pathToFolder, function(folder){
    //This will loop over all folders inside pathToFolder main, secondary 
    //Return stream so gulp-folders can concatenate all of them 
    //so you still can use safely use gulp multitasking 
 
    return gulp.src(path.join(pathToFolder, folder, '*.js'))
        .pipe(concat(folder + '.js'))
        .pipe(gulp.dest('dist'));
}));