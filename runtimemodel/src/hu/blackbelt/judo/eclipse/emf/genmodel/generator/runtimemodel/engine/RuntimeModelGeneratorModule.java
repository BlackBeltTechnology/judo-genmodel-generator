package hu.blackbelt.judo.eclipse.emf.genmodel.generator.runtimemodel.engine;

import org.eclipse.xtext.generator.IGenerator;
import hu.blackbelt.eclipse.emf.genmodel.generator.core.engine.AbstractGenModelGeneratorModule;
import hu.blackbelt.judo.eclipse.emf.genmodel.generator.runtimemodel.templates.RuntimeModelGenerator;

public class RuntimeModelGeneratorModule extends AbstractGenModelGeneratorModule {
	public Class<? extends IGenerator> bindIGenerator() {
		return RuntimeModelGenerator.class;
	}
}
