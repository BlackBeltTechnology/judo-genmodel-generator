package hu.blackbelt.judo.eclipse.emf.genmodel.generator.runtimemodel.engine;

import org.eclipse.xtend.lib.annotations.Accessors
import hu.blackbelt.eclipse.emf.genmodel.generator.core.engine.GeneratorConfig

@Accessors
class RuntimeModelGeneratorConfig extends GeneratorConfig {
	String resolveModelName = "";
	String resolveModelVersion = "";

}
