package public

import (
	"fmt"
	"log"
	"path"
	"runtime"
)

func Println(v ...interface{}) {
	_, file, line, _ := runtime.Caller(1)
	log.Printf("%s:%d: %s", path.Base(file), line, fmt.Sprintln(v...))
}

func Printf(format string, v ...interface{}) {
	_, file, line, _ := runtime.Caller(1)
	log.Printf("%s:%d: %s", path.Base(file), line, fmt.Sprintf(format, v...))
}

func FatalError(err error) {
	if err != nil {
		_, file, line, _ := runtime.Caller(1)
		log.Fatalf("%s:%d: %s\n", path.Base(file), line, err)
	}
}

func HasError(err error, v ...interface{}) bool {
	if err != nil {
		_, file, line, _ := runtime.Caller(1)
		log.Printf("%s:%d: %s, %s\n", path.Base(file), line, err, fmt.Sprint(v...))
		return true
	}
	return false
}

func BuildError(show bool, format string, v ...interface{}) error {
	_, file, line, _ := runtime.Caller(1)
	err := fmt.Errorf("%s:%d %s", path.Base(file), line, fmt.Sprintf(format, v...))
	if show == true {
		log.Printf(err.Error())
	}
	return err
}
