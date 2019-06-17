package hu.blackbelt.judo.eclipse.emf.genmodel.generator.runtimemodel.engine;

import hu.blackbelt.eclipse.emf.genmodel.generator.core.engine.AbstractGenModelGeneratorModule;
import hu.blackbelt.eclipse.emf.genmodel.generator.core.engine.AbstractGenModelGeneratorStandaloneSetup;

public class RuntimeModelGeneratorStandaloneSetup extends AbstractGenModelGeneratorStandaloneSetup {

	@Override
	public AbstractGenModelGeneratorModule getGenModelModule() {
		// TODO Auto-generated method stub
		return new RuntimeModelGeneratorModule();
	}
}
