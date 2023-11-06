package hu.blackbelt.judo.eclipse.emf.genmodel.generator.runtimemodel.templates;

import com.google.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IGenerator2
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext

class RuntimeModelGenerator implements IGenerator2 {
    @Inject RuntimeModel runtimeModel
    // add more templates here
				
	override afterGenerate(Resource input, IFileSystemAccess2 fsa, IGeneratorContext context) {
	}
	
	override beforeGenerate(Resource input, IFileSystemAccess2 fsa, IGeneratorContext context) {
	}
	
	override doGenerate(Resource input, IFileSystemAccess2 fsa, IGeneratorContext context) {
        runtimeModel.doGenerate(input,fsa)
	}
}
