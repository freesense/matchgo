package public

import (
	"fmt"
	"log"
	"path"
	"runtime"

	opencc "github.com/stevenyao/go-opencc"
)

var config_s2t = "./s2t.json"
var s2t *opencc.Converter

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

type MyError struct {
	enFmt, cnFmt, twFmt string
}

func NewMyError(enFormat, cnFormat string) *MyError {
	var obj = new(MyError)
	obj.enFmt = enFormat
	obj.cnFmt = cnFormat
	s2t = opencc.NewConverter(config_s2t)
	defer s2t.Close()
	obj.twFmt = s2t.Convert(obj.cnFmt)
	return obj
}

func (self *MyError) Build(lang string, v ...interface{}) (err error) {
	_, file, line, _ := runtime.Caller(1)
	switch lang {
	case "zh-cn", "cn", "chs", "zh_cn":
		err = fmt.Errorf("%s:%d %s", path.Base(file), line, fmt.Sprintf(self.cnFmt, v...))
	case "zh-tw", "tw", "cht", "zh_tw":
		err = fmt.Errorf("%s:%d %s", path.Base(file), line, fmt.Sprintf(self.twFmt, v...))
	default:
		err = fmt.Errorf("%s:%d %s", path.Base(file), line, fmt.Sprintf(self.enFmt, v...))
	}
	return
}

func ShowError(err error) error {
	log.Printf(err.Error())
	return err
}

func BuildError(show, cht bool, format string, v ...interface{}) (err error) {
	_, file, line, _ := runtime.Caller(1)
	msg := fmt.Sprintf(format, v...)
	if cht {
		s2t = opencc.NewConverter(config_s2t)
		defer s2t.Close()
		msg = s2t.Convert(msg)
	}
	if err = fmt.Errorf("%s:%d %s", path.Base(file), line, msg); HasError(err) {
		return
	}
	if show == true {
		log.Printf(err.Error())
	}
	return
}
