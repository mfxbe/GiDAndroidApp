import gio.types : ApplicationFlags;
import gtk.application;
import gtk.application_window;
import gtk.label;
import core.runtime;

class ExampleApp:Application{
        this() {
                super("de.mfxbe.GiDAndroidApp", ApplicationFlags.DefaultFlags);
                connectActivate(&onActivate);
        }

        void onActivate(){
                auto window = new ApplicationWindow(this);
                window.setDefaultSize(200, 200);
                auto label = new Label("Hello World");
                window.setChild(label);

                window.present();
        }
}


version(Android){
	extern(C) int main(int argc, char** argv){
		rt_init();

		import gio.c.functions;
		import gio.c.types;
		
		auto app = new ExampleApp;
		auto res = g_application_run(cast(GApplication*)app._cPtr, argc, argv);
		
		rt_term();
		return(res);
	}
} else {
	void main(string[] args) {
		    auto app = new ExampleApp;
		    app.run(args);
	}
}
