package hu.blackbelt.judo.eclipse.emf.genmodel.generator.runtimemodel.templates;

import javax.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.emf.codegen.ecore.genmodel.GenModel
import hu.blackbelt.judo.eclipse.emf.genmodel.generator.runtimemodel.engine.RuntimeModelGeneratorConfig

class RuntimeModel implements IGenerator {
	@Inject extension Naming
	@Inject RuntimeModelGeneratorConfig config

	override doGenerate(Resource input, IFileSystemAccess fsa) {		
		input.allContents.filter(GenModel).forEach[
			val content = generate
			fsa.generateFile(packagePath + "/runtime/" + modelName + "Model.java", content)
		]
	}
	
	def generate (GenModel it) 
	'''
		package «packageName».runtime;
		
		import org.eclipse.emf.common.util.Diagnostic;
		import org.eclipse.emf.common.util.URI;
		import org.eclipse.emf.ecore.EObject;
		import org.eclipse.emf.ecore.resource.Resource;
		import org.eclipse.emf.ecore.resource.ResourceSet;
		import org.eclipse.emf.ecore.resource.URIHandler;
		
		import «packageName».support.«modelName»ModelResourceSupport;
		
		import java.io.*;
		import java.util.Collections;
		import java.util.Dictionary;
		import java.util.Hashtable;
		import java.util.Map;
		import java.util.Optional;
		import java.util.Set;
		
		import static «packageName».support.«modelName»ModelResourceSupport.setupRelativeUriRoot;
		import static java.util.Objects.requireNonNull;
		import static java.util.Optional.ofNullable;
		import static org.eclipse.emf.common.util.URI.createURI;
				
		/**
		 * A wrapper class on a «modelName» metamodel based model. This wrapper organizing the model a structure which can be used
		 * in Tatami as a logical model.
		 * The logical model have version and loaded resources. The logical model can handle load and save from / to different
		 * type of input / output source.
		 *
		 * Examples:
		 *
		 * Load an model from file.
		 * <pre>
		 *    «modelName»Model «modelName.decapitalize»Model = «modelName»Model.load«modelName»Model(«modelName.decapitalize»LoadArgumentsBuilder()
		 *                 .uri(org.eclipse.emf.common.util.URI.createFileURI(new File("src/test/model/test.«modelName.decapitalize»").getAbsolutePath()))
		 «IF config.resolveModelName.blank»
		 *                 .name("test")
		 «ENDIF»
		 *                 .build());
		 *
		 * </pre>
		 *
		 * More complex example, where model is loaded over an {@link URIHandler} in OSGi environment.
		 *
		 * <pre>
		 *
		 *    BundleURIHandler bundleURIHandler = new BundleURIHandler("urn", "", bundleContext.getBundle());
		 *
		 *    «modelName»Model «modelName.decapitalize»Model = «modelName»Model.build«modelName»Model()
		 «IF config.resolveModelName.blank»
		 *                 .name("test")
		 «ENDIF»
		 «IF config.resolveModelVersion.blank»
		 *                 .version("1.0.0")
		 «ENDIF»
		 *                 .uri(org.eclipse.emf.common.util.URI.createURI("urn:test.«modelName.decapitalize»"))
		 *                 .uriHandler(bundleURIHandler)
		 * </pre>
		 *
		 * Create an empty «modelName.decapitalize» model
		 * <pre>
		 *    «modelName»Model «modelName.decapitalize»Model = «modelName»Model.build«modelName»Model()
		 «IF config.resolveModelName.blank»
		 *                 .name("test")
		 «ENDIF»
		 *                 .uri(URI.createFileURI("test.model"))
		 *                 .build()
		 * </pre>
		 *
		 */
		public class «modelName»Model {
		
		    public static final String NAME = "name";
		    public static final String VERSION = "version";
		    public static final String URI = "uri";
		    public static final String RESOURCESET = "resourceset";
		
		    «IF config.resolveModelName.blank»
		        private String name;
		    «ENDIF»
		    «IF config.resolveModelVersion.blank»
		        private String version;
		    «ENDIF»
		    private URI uri;
		    private «modelName»ModelResourceSupport «modelName.decapitalize»ModelResourceSupport;
		    
		    /**
		     * Return the model's name
		     * @return model's name
		     */
		    public String getName() {
		    	«IF config.resolveModelName.blank»
		    	   return name;
		    	«ELSE»
		    	   return «config.resolveModelName»;
		    	«ENDIF»
			}

		    /**
		     * Return the model's version
		     * @return model's version
		     */
		    public String getVersion() {
		    	«IF config.resolveModelVersion.blank»
		    	   return version;
		    	«ELSE»
		    	   return «config.resolveModelVersion»;
		    	«ENDIF»
			}
		
		    /**
		     * Return all properties as a {@link Dictionary}
		     * @return
		     */
		    public Dictionary<String, Object> toDictionary() {
		        Dictionary<String, Object> ret = new Hashtable<>();
		        ret.put(NAME, getName());
		        ret.put(VERSION, getVersion());
		        ret.put(URI, uri);
		        ret.put(RESOURCESET, «modelName.decapitalize»ModelResourceSupport.getResourceSet());
		        return ret;
		    }
		
		    /**
		     * Get the model's {@link «modelName»ModelResourceSupport} resource helper itself.
		     * @return instance of {@link «modelName»ModelResourceSupport}
		     */
		    public «modelName»ModelResourceSupport get«modelName»ModelResourceSupport() {
		        return «modelName.decapitalize»ModelResourceSupport;
		    }
		
		    /**
		     * Get the model's isolated {@link ResourceSet}
		     * @return instance of {@link ResourceSet}
		     */
		    public ResourceSet getResourceSet() {
		        return «modelName.decapitalize»ModelResourceSupport.getResourceSet();
		    }
		
		
		    /**
		     * Get the model's root resource which represents the mdoel's uri {@link URI} itself.
		     * If the given resource does not exists new one is created.
		     * @return instance of {@link Resource}
		     */
		    public Resource getResource() {
		        if (getResourceSet().getResource(uri, false) == null) {
		            getResourceSet().createResource(uri);
		        }
		        return getResourceSet().getResource(uri, false);
		    }
		
		    /**
		     * Add content to the given model's root.
		     * @param object Object to add to resource.
		     * @return return this instance
		     */
		    @SuppressWarnings("UnusedReturnValue")
		    public «modelName»Model addContent(EObject object) {
		        getResource().getContents().add(object);
		        return this;
		    }
		
		    /**
		     * Load an model into {@link «modelName»Model} default {@link Resource}.
		     * The {@link URI}, {@link URIHandler} and {@link ResourceSet} arguments are not used here, because it has
		     * already set.
		     * @param loadArgumentsBuilder {@link LoadArguments.LoadArgumentsBuilder} used for load.
		     * @return this {@link «modelName»ModelResourceSupport}
		     * @throws IOException when IO error occured
		     * @throws «modelName»ValidationException when model validation is true and the model is invalid.
		     */
		    public «modelName»Model loadResource(LoadArguments.LoadArgumentsBuilder
		                                                        loadArgumentsBuilder)
		            throws IOException, «modelName»ValidationException {
		        return loadResource(loadArgumentsBuilder.build());
		    }
		
		    /**
		     * Load an model into {@link «modelName»Model} default {@link Resource}.
		     * The {@link URI}, {@link URIHandler} and {@link ResourceSet} arguments are not used here, because it has
		     * already set.
		     * @param loadArguments {@link LoadArguments} used for load.
		     * @return this {@link «modelName»ModelResourceSupport}
		     * @throws IOException when IO error occured
		     * @throws «modelName»ValidationException when model validation is true and the model is invalid.
		     */
		    @SuppressWarnings("WeakerAccess")
		    public «modelName»Model loadResource(LoadArguments loadArguments)
		            throws IOException, «modelName»ValidationException {
		
		        Resource resource = getResource();
		        Map loadOptions = loadArguments.getLoadOptions()
		                .orElseGet(«modelName»ModelResourceSupport::get«modelName»ModelDefaultLoadOptions);
		
		        try {
		            InputStream inputStream = loadArguments.getInputStream()
		                    .orElseGet(() -> loadArguments.getFile().map(f -> {
		                        try {
		                            return new FileInputStream(f);
		                        } catch (FileNotFoundException e) {
		                            throw new RuntimeException(e);
		                        }
		                    }).orElse(null));
		
		            if (inputStream != null) {
		                resource.load(inputStream, loadOptions);
		            } else {
		                resource.load(loadOptions);
		            }
		
		        } catch (RuntimeException e) {
		            if (e.getCause() instanceof IOException) {
		                throw (IOException) e.getCause();
		            } else {
		                throw e;
		            }
		        }
		
		        if (loadArguments.isValidateModel() && !isValid()) {
		            throw new «modelName»ValidationException(this);
		        }
		        return this;
		    }
		
		    /**
		     * Load an model. {@link LoadArguments.LoadArgumentsBuilder} contains all parameter
		     * @param loadArgumentsBuilder {@link LoadArguments.LoadArgumentsBuilder} used for load
		     * @return new {@link «modelName»Model} instance
		     * @throws IOException when IO error occured
		     * @throws «modelName»ValidationException when model validation is true and the model is invalid.
		     */
		    public static «modelName»Model load«modelName»Model(LoadArguments.LoadArgumentsBuilder loadArgumentsBuilder)
		            throws IOException, «modelName»ValidationException {
		        return load«modelName»Model(loadArgumentsBuilder.build());
		    }
		
		    /**
		     * Load an model. {@link LoadArguments} contains all parameter
		     * @param loadArguments {@link LoadArguments.LoadArgumentsBuilder} used for load
		     * @return new {@link «modelName»Model} instance.
		     * @throws IOException when IO error occured
		     * @throws «modelName»ValidationException when model validation is true and the model is invalid.
		     */
		    public static «modelName»Model load«modelName»Model(LoadArguments loadArguments) throws IOException, «modelName»ValidationException {
		        try {
		            «modelName»ModelResourceSupport «modelName.decapitalize»ModelResourceSupport = «modelName»ModelResourceSupport
		                    .load«modelName»(loadArguments.to«modelName»ModelResourceSupportLoadArgumentsBuilder()
		                            .validateModel(false));
		            «modelName»Model «modelName.decapitalize»Model = build«modelName»Model()
		                    «IF config.resolveModelName.blank»
		                        .name(loadArguments.getName()
		                                .orElseThrow(() -> new IllegalArgumentException("Name is mandatory")))
		                    «ENDIF»
		                    «IF config.resolveModelVersion.blank»
		                    .version(loadArguments.getVersion()
		                            .orElse("0.0.0"))
                            «ENDIF»
		                    .uri(loadArguments.getUri().orElseGet(() -> 
		                            «IF config.resolveModelName.blank»
		                                createURI(loadArguments.name + "-«modelName.decapitalize».model")))
		                            «ELSE»
		                                createURI("«modelName.decapitalize».model")))
		                            «ENDIF»
		                    .«modelName.decapitalize»ModelResourceSupport(«modelName.decapitalize»ModelResourceSupport)
		                    .build();
		
		            setupRelativeUriRoot(«modelName.decapitalize»Model.getResourceSet(), loadArguments.uri);
		
		            if (loadArguments.validateModel && !«modelName.decapitalize»ModelResourceSupport.isValid()) {
		                throw new «modelName»ValidationException(«modelName.decapitalize»Model);
		            }
		            return «modelName.decapitalize»Model;
		
		        } catch («modelName»ModelResourceSupport.«modelName»ValidationException ignore) {
		            throw new IllegalStateException("This exception generated because the code is broken");
		        }
		    }
		
		    /**
		     * Save the model to the given URI.
		     * @throws IOException when IO error occurred
		     * @throws «modelName»ValidationException when model validation is true and the model is invalid.
		     */
		    public void save«modelName»Model() throws IOException, «modelName»ValidationException {
		        save«modelName»Model(SaveArguments.«modelName.decapitalize»SaveArgumentsBuilder());
		    }
		
		    /**
		     * Save the model as the given {@link SaveArguments.SaveArgumentsBuilder} defines
		     * @param saveArgumentsBuilder the {@link SaveArguments.SaveArgumentsBuilder} used for save
		     * @throws IOException when IO error occurred
		     * @throws «modelName»ValidationException when model validation is true and the model is invalid.
		     */
		    public void save«modelName»Model(SaveArguments.SaveArgumentsBuilder saveArgumentsBuilder)
		            throws IOException, «modelName»ValidationException {
		        save«modelName»Model(saveArgumentsBuilder.build());
		    }
		
		    /**
		     * Save the model as the given {@link SaveArguments} defines
		     * @param saveArguments the {@link SaveArguments} used for save
		     * @throws IOException when IO error occurred
		     * @throws «modelName»ValidationException when model validation is true and the model is invalid.
		     */
		    public void save«modelName»Model(SaveArguments saveArguments) throws IOException, «modelName»ValidationException {
		        if (saveArguments.validateModel && !«modelName.decapitalize»ModelResourceSupport.isValid()) {
		            throw new «modelName»ValidationException(this);
		        }
		        try {
		            «modelName.decapitalize»ModelResourceSupport.save«modelName»(saveArguments.to«modelName»ModelResourceSupportSaveArgumentsBuilder()
		                    .validateModel(false));
		        } catch («modelName»ModelResourceSupport.«modelName»ValidationException e) {
		            // Validation disaled, this exception cannot be thrown
		        }
		    }
		
		    /**
		     * Get distinct diagnostics for model. Only  {@link Diagnostic}.WARN and {@link Diagnostic}.ERROR are returns.
		     * @return set of {@link Diagnostic}
		     */
		    public Set<Diagnostic> getDiagnostics() {
		        return «modelName.decapitalize»ModelResourceSupport.getDiagnostics();
		    }
		
		    /**
		     * Checks the model have any {@link Diagnostic}.ERROR diagnostics. When there is no any the model assumed as valid.
		     * @return true when model is valid
		     */
		    public boolean isValid() {
		        return «modelName.decapitalize»ModelResourceSupport.isValid();
		    }
		
		    /**
		     * Print model as string
		     * @return model as XML string
		     */
		    @SuppressWarnings("WeakerAccess")
		    public String asString() {
		        return «modelName.decapitalize»ModelResourceSupport.asString();
		    }
		
		    /**
		     * Get diagnostics as a String
		     * @return diagnostic list as string. Every line represents one diagnostic.
		     */
		    @SuppressWarnings("WeakerAccess")
		    public String getDiagnosticsAsString() {
		        return «modelName.decapitalize»ModelResourceSupport.getDiagnosticsAsString();
		    }
		
		    /**
		     * This exception is thrown when validateModel is true on load or save and the model is not conform with its
		     * defined metamodel.
		     */
		    @SuppressWarnings("WeakerAccess")
		    public static class «modelName»ValidationException extends Exception {
		        «modelName»Model «modelName.decapitalize»Model;
		
		        public «modelName»ValidationException(«modelName»Model «modelName.decapitalize»Model) {
		            «IF config.printXmlOnError»
		                super("Invalid model\n" +
		                        «modelName.decapitalize»Model.getDiagnosticsAsString() + "\n" +
		                        «modelName.decapitalize»Model.asString());
		            «ELSE»
		                super("Invalid model\n" + «modelName.decapitalize»Model.getDiagnosticsAsString());
		            «ENDIF»
		            this.«modelName.decapitalize»Model = «modelName.decapitalize»Model;
		        }
		    }
		
		    /**
		     * Arguments for {@link «modelName»Model#load«modelName»Model(LoadArguments)}
		     * It can handle variance of the presented arguments.
		     */
		    public static class LoadArguments {
		        URI uri;
		        «IF config.resolveModelName.blank»
		        String name;
		        «ENDIF»
		        URIHandler uriHandler;
		        ResourceSet resourceSet;
		        «IF config.resolveModelName.blank»
		        String version;
		        «ENDIF»
		        Map<Object, Object> loadOptions;
		        boolean validateModel;
		        InputStream inputStream;
		        File file;
		
		        private static URIHandler $default$uriHandler() {
		            return null;
		        }
		
		        private static ResourceSet $default$resourceSet() {
		            return null;
		        }
		        «IF config.resolveModelVersion.blank»
		        private static String $default$version() {
		            return "1.0.0";
		        }
		        «ENDIF»
				
		        private static File $default$file() {
		            return null;
		        }
		
		        private static InputStream $default$inputStream() {
		            return null;
		        }

		        private static Map<Object, Object> $default$loadOptions() {
		            return «modelName»ModelResourceSupport.get«modelName»ModelDefaultLoadOptions();
		        }
		
		        Optional<URI> getUri() {
		            return ofNullable(uri);
		        }
		        «IF config.resolveModelName.blank»	
		        Optional<String> getName() {
		            return ofNullable(name);
		            
		        }
		        «ENDIF»
		
		        Optional<URIHandler> getUriHandler() {
		            return ofNullable(uriHandler);
		        }
		
		        Optional<ResourceSet> getResourceSet() {
		            return ofNullable(resourceSet);
		        }
		        «IF config.resolveModelVersion.blank»
		        Optional<String> getVersion() {
		            return ofNullable(version);
		        }
		        «ENDIF»
				
		        Optional<Map<Object, Object>> getLoadOptions() {
		            return ofNullable(loadOptions);
		        }
		
		        boolean isValidateModel() {
		            return validateModel;
		        }
		
		        Optional<File> getFile() {
		            return ofNullable(file);
		        }
		
		        Optional<InputStream> getInputStream() {
		            return ofNullable(inputStream);
		        }
		
		        /**
		         * Builder for {@link «modelName»Model#load«modelName»Model(LoadArguments)}.
		         */
		        public static class LoadArgumentsBuilder {
		            private URI uri;
		            «IF config.resolveModelName.blank»
		            private String name;
		            «ENDIF»
		
		            private boolean uriHandler$set;
		            private URIHandler uriHandler;
		            
		            private boolean resourceSet$set;
		            private ResourceSet resourceSet;
		            
		            «IF config.resolveModelVersion.blank»
		            private boolean version$set;
		            private String version;
		            «ENDIF»
		            		            
		            private boolean loadOptions$set;
		            private Map<Object, Object> loadOptions;
		
		            private boolean validateModel = true;
		
		            private boolean file$set;
		            private File file;
		
		            
		            private boolean inputStream$set;
		            private InputStream inputStream;
		
		            
		            LoadArgumentsBuilder() {
		            }
		
		            /**
		             * Defines the {@link URI} of the model.
		             * This is mandatory.
		             */
		            public LoadArgumentsBuilder uri(final URI uri) {
		                requireNonNull(uri);
		                this.uri = uri;
		                return this;
		            }
		
		            «IF config.resolveModelName.blank»
		            /**
		             * Defines the name of the model.
		             * This is mandatory.
		             */
		            public LoadArgumentsBuilder name(final String name) {
		                requireNonNull(name);
		                this.name = name;
		                return this;
		            }
		            «ENDIF»
		
		            /**
		             * Defines the {@link URIHandler} used for model IO. If not defined the default is EMF used.
		             */
		            public LoadArgumentsBuilder uriHandler(final URIHandler uriHandler) {
		                requireNonNull(uriHandler);
		                this.uriHandler = uriHandler;
		                uriHandler$set = true;
		                return this;
		            }
		
		            
		            /**
		             * Defines the default {@link ResourceSet}. If it is not defined the factory based resourceSet is used.
		             */
		            public LoadArgumentsBuilder resourceSet(final ResourceSet resourceSet) {
		                requireNonNull(resourceSet);
		                this.resourceSet = resourceSet;
		                resourceSet$set = true;
		                return this;
		            }
		
		            «IF config.resolveModelVersion.blank»
		            /**
		             * Defines the model version. If its not defined the version will be 1.0.0
		             */
		            public LoadArgumentsBuilder version(final String version) {
		                requireNonNull(version);
		                this.version = version;
		                version$set = true;
		                return this;
		            }
		            «ENDIF»
		            
		            /**
		             * Defines the load options for model. If not defined the
		             * {@link «modelName»ModelResourceSupport#get«modelName»ModelDefaultLoadOptions()} us used.
		             */
		            public LoadArgumentsBuilder loadOptions(final Map<Object, Object> loadOptions) {
		                requireNonNull(loadOptions);
		                this.loadOptions = loadOptions;
		                loadOptions$set = true;
		                return this;
		            }
		
		            
		            /**
		             * Defines that model validation required or not on load. Default: true
		             */
		            public LoadArgumentsBuilder validateModel(boolean validateModel) {
		                this.validateModel = validateModel;
		                return this;
		            }
		
		            
		            /**
		             * Defines the file if it is not loaded from URI. If not defined, URI is used. If inputStream is defined
		             * it is used.
		             */
		            public LoadArgumentsBuilder file(final File file) {
		                requireNonNull(file);
		                this.file = file;
		                file$set = true;
		                return this;
		            }
		
		            
		            /**
		             * Defines the file if it is not loaded from  File or URI. If not defined, File or URI is used.
		             */
		            public LoadArgumentsBuilder inputStream(final InputStream inputStream) {
		                requireNonNull(inputStream);
		                this.inputStream = inputStream;
		                inputStream$set = true;
		                return this;
		            }
		
		            public LoadArguments build() {
		                URIHandler uriHandler = this.uriHandler;
		                if (!uriHandler$set) uriHandler = LoadArguments.$default$uriHandler();
		                ResourceSet resourceSet = this.resourceSet;
		                if (!resourceSet$set) resourceSet = LoadArguments.$default$resourceSet();
		                «IF config.resolveModelVersion.blank»
		                String version = this.version;
		                if (!version$set) version = LoadArguments.$default$version();
		                «ENDIF»

		                Map<Object, Object> loadOptions = this.loadOptions;
		                if (!loadOptions$set) loadOptions = LoadArguments.$default$loadOptions();
		                File file = this.file;
		                if (!file$set) file = LoadArguments.$default$file();
		                InputStream inputStream = this.inputStream;
		                if (!inputStream$set) inputStream = LoadArguments.$default$inputStream();
		
		                return new LoadArguments(
		                        uri, 
		                        «IF config.resolveModelName.blank»
		                        name, 
		                        «ENDIF»
		                        uriHandler, 
		                        resourceSet, 
		                        «IF config.resolveModelName.blank»
		                        version,
		                        «ENDIF»
		                        loadOptions, 
		                        validateModel, 
		                        file, 
		                        inputStream);
		            }
		
		            @java.lang.Override
		            
		            public java.lang.String toString() {
		                return "«modelName»Model.LoadArguments.LoadArgumentsBuilder(uri=" + this.uri
		                        «IF config.resolveModelName.blank»
		                        + ", name=" + this.name
		                        «ENDIF»
		                        + ", uriHandler=" + this.uriHandler
		                        + ", resourceSet=" + this.resourceSet
		                        «IF config.resolveModelVersion.blank»
		                        + ", version=" + this.version
		                        «ENDIF»
		                        + ", loadOptions=" + this.loadOptions
		                        + ", validateModel=" + this.validateModel
		                        + ", file=" + this.file
		                        + ", inputStream=" + this.inputStream
		                        + ")";
		            }
		        }
		
		        
		        public static LoadArgumentsBuilder «modelName.decapitalize»LoadArgumentsBuilder() {
		            return new LoadArgumentsBuilder();
		        }
		
		        
		        private LoadArguments(final URI uri,
		                              «IF config.resolveModelName.blank»
		                              final String name,
		                              «ENDIF»
		                              final URIHandler uriHandler,
		                              final ResourceSet resourceSet,
		                              «IF config.resolveModelVersion.blank»
		                              final String version,
		                              «ENDIF»
		                              final Map<Object, Object> loadOptions,
		                              final boolean validateModel,
		                              final File file,
		                              final InputStream inputStream) {
		            this.uri = uri;
		            «IF config.resolveModelName.blank»
		            this.name = name;
		            «ENDIF»
		            this.uriHandler = uriHandler;
		            this.resourceSet = resourceSet;
		            «IF config.resolveModelVersion.blank»
		            this.version = version;
		            «ENDIF»
		            this.loadOptions = loadOptions;
		            this.validateModel = validateModel;
		            this.file = file;
		            this.inputStream = inputStream;
		        }
		
		        
		        «modelName»ModelResourceSupport.LoadArguments.LoadArgumentsBuilder
		                    to«modelName»ModelResourceSupportLoadArgumentsBuilder() {
		            «modelName»ModelResourceSupport.LoadArguments.LoadArgumentsBuilder argumentsBuilder =
		                    «modelName»ModelResourceSupport.LoadArguments.«modelName.decapitalize»LoadArgumentsBuilder()
		                            .uri(getUri()
		                                    .orElseGet(() ->
		                                        «IF config.resolveModelName.blank»
		                                            createURI(getName().get() + "-«modelName.decapitalize».model")))
                                                «ELSE»
		                                            createURI("«modelName.decapitalize».model")))
                                                «ENDIF»
		                            .validateModel(isValidateModel());
		
		            getUriHandler().ifPresent(argumentsBuilder::uriHandler);
		            getResourceSet().ifPresent(argumentsBuilder::resourceSet);
		            getLoadOptions().ifPresent(argumentsBuilder::loadOptions);
		            getFile().ifPresent(argumentsBuilder::file);
		            getInputStream().ifPresent(argumentsBuilder::inputStream);
		
		            return argumentsBuilder;
		        }
		
		
		    }
		
		
		    /**
		     * Arguments for {@link «modelName»Model#save«modelName»Model(SaveArguments)}
		     * It can handle variance of the presented arguments.
		     */
		    public static class SaveArguments {
		        OutputStream outputStream;
		        File file;
		        Map<Object, Object> saveOptions;
		        boolean validateModel;
		
		        private static OutputStream $default$outputStream() {
		            return null;
		        }
		
		        private static File $default$file() {
		            return null;
		        }
		
		        private static Map<Object, Object> $default$saveOptions() {
		            return null;
		        }
		
		        public Optional<OutputStream> getOutputStream() {
		            return ofNullable(outputStream);
		        }
		
		        public Optional<File> getFile() {
		            return ofNullable(file);
		        }
		
		        public Optional<Map<Object, Object>> getSaveOptions() {
		            return ofNullable(saveOptions);
		        }
		
		        public boolean isValidateModel() {
		            return validateModel;
		        }
		
		        /**
		         * Builder for {@link «modelName»Model#save«modelName»Model(SaveArguments)}.
		         */
		        public static class SaveArgumentsBuilder {
		            
		            private boolean outputStream$set;
		            private OutputStream outputStream;
		            
		            private boolean file$set;
		            private File file;
		            
		            private boolean saveOptions$set;
		            private Map<Object, Object> saveOptions;
		
		            private boolean validateModel = true;
		
		            
		            SaveArgumentsBuilder() {
		            }
		
		            
		            public «modelName»ModelResourceSupport.SaveArguments.SaveArgumentsBuilder
		                        to«modelName»ModelResourceSupportSaveArgumentsBuilder() {
		                «modelName»ModelResourceSupport.SaveArguments.SaveArgumentsBuilder argumentsBuilder =
		                        «modelName»ModelResourceSupport.SaveArguments.«modelName.decapitalize»SaveArgumentsBuilder().validateModel(validateModel);
		
		                if (outputStream$set) argumentsBuilder.outputStream(outputStream);
		                if (file$set) argumentsBuilder.file(file);
		                if (saveOptions$set) argumentsBuilder.saveOptions(saveOptions);
		                return argumentsBuilder;
		            }
		
		            
		            /**
		             * Defines {@link OutputStream} which is used by save. Whe it is not defined, file is used.
		             */
		            public SaveArgumentsBuilder outputStream(final OutputStream outputStream) {
		                requireNonNull(outputStream);
		                this.outputStream = outputStream;
		                outputStream$set = true;
		                return this;
		            }
		
		            
		            /**
		             * Defines {@link File} which is used by save. Whe it is not defined the model's
		             * {@link «modelName»Model#uri is used}
		             */
		            public SaveArgumentsBuilder file(File file) {
		                requireNonNull(file);
		                this.file = file;
		                file$set = true;
		                return this;
		            }
		
		            
		            /**
		             * Defines save options. When it is not defined
		             * {@link «modelName»ModelResourceSupport#get«modelName»ModelDefaultSaveOptions()} is used.
		             */
		            public SaveArgumentsBuilder saveOptions(final Map<Object, Object> saveOptions) {
		                requireNonNull(saveOptions);
		                this.saveOptions = saveOptions;
		                saveOptions$set = true;
		                return this;
		            }
		
		            /**
		             * Defines that model validation required or not on save. Default: true
		             */
		            public SaveArgumentsBuilder validateModel(boolean validateModel) {
		                this.validateModel = validateModel;
		                return this;
		            }
		
		            
		            public SaveArguments build() {
		                OutputStream outputStream = this.outputStream;
		                if (!outputStream$set) outputStream = SaveArguments.$default$outputStream();
		                File file = this.file;
		                if (!file$set) file = SaveArguments.$default$file();
		                Map<Object, Object> saveOptions = this.saveOptions;
		                if (!saveOptions$set) saveOptions = SaveArguments.$default$saveOptions();
		                return new SaveArguments(outputStream, file, saveOptions, validateModel);
		            }
		
		            @java.lang.Override
		            
		            public java.lang.String toString() {
		                return "«modelName»Model.SaveArguments.SaveArgumentsBuilder("
		                        + "outputStream=" + this.outputStream
		                        + ", file=" + this.file
		                        + ", saveOptions=" + this.saveOptions
		                        + ")";
		            }
		        }
		
		        
		        public static SaveArgumentsBuilder «modelName.decapitalize»SaveArgumentsBuilder() {
		            return new SaveArgumentsBuilder();
		        }
		
		        
		        public «modelName»ModelResourceSupport.SaveArguments.SaveArgumentsBuilder to«modelName»ModelResourceSupportSaveArgumentsBuilder() {
		            «modelName»ModelResourceSupport.SaveArguments.SaveArgumentsBuilder argumentsBuilder =
		                    «modelName»ModelResourceSupport.SaveArguments.«modelName.decapitalize»SaveArgumentsBuilder().validateModel(validateModel);
		
		            getOutputStream().ifPresent(o -> argumentsBuilder.outputStream(o));
		            getFile().ifPresent(o -> argumentsBuilder.file(o));
		            getSaveOptions().ifPresent(o -> argumentsBuilder.saveOptions(o));
		            return argumentsBuilder;
		        }
		
		
		        
		        private SaveArguments(final OutputStream outputStream,
		                              final File file,
		                              final Map<Object, Object> saveOptions,
		                              final boolean validateModel) {
		            this.outputStream = outputStream;
		            this.file = file;
		            this.saveOptions = saveOptions;
		            this.validateModel = validateModel;
		        }
		    }
		
		
		    
		    public static class «modelName»ModelBuilder {
		
		        «IF config.resolveModelName.blank»
		        private String name;
		        «ENDIF»
		        private URI uri;
		
		        «IF config.resolveModelVersion.blank»
		        private boolean version$set;
		        private String version;
		        «ENDIF»
				
		        private boolean «modelName.decapitalize»ModelResourceSupport$set;
		        private «modelName»ModelResourceSupport «modelName.decapitalize»ModelResourceSupport;
		
		        private boolean resourceSet$set;
		        private ResourceSet resourceSet;
		
		        private URIHandler uriHandler;
		        private boolean uriHandler$set;
		
		        «modelName»ModelBuilder() {
		        }
		
		
		        «IF config.resolveModelName.blank»
		        /**
		         * Defines name of the model. Its mandatory.
		         */
		        public «modelName»ModelBuilder name(final String name) {
		            this.name = name;
		            return this;
		        }
		        «ENDIF»
		
		        
		        /**
		         * Defines the uri {@link URI} of the model. Its mandatory.
		         */
		        public «modelName»ModelBuilder uri(final URI uri) {
		            this.uri = uri;
		            return this;
		        }
		
		        «IF config.resolveModelVersion.blank»
		        /**
		         * Defines the version of the model. Its mandatory.
		         */
		        public «modelName»ModelBuilder version(final String version) {
		            requireNonNull(version);
		            this.version = version;
		            version$set = true;
		            return this;
		        }
		        «ENDIF»

		        public «modelName»ModelBuilder «modelName.decapitalize»ModelResourceSupport(final «modelName»ModelResourceSupport «modelName.decapitalize»ModelResourceSupport) {
		            requireNonNull(«modelName.decapitalize»ModelResourceSupport);
		            this.«modelName.decapitalize»ModelResourceSupport = «modelName.decapitalize»ModelResourceSupport;
		            this.«modelName.decapitalize»ModelResourceSupport$set = true;
		            return this;
		        }
		
		        public «modelName»ModelBuilder resourceSet(final ResourceSet resourceSet) {
		            requireNonNull(resourceSet);
		            this.resourceSet = resourceSet;
		            this.resourceSet$set = true;
		            return this;
		        }
		
		        public «modelName»ModelBuilder uriHandler(final URIHandler uriHandler) {
		            requireNonNull(uriHandler);
		            this.uriHandler = uriHandler;
		            this.uriHandler$set = true;
		            return this;
		        }
		
		
		        public «modelName»Model build() {
		            org.eclipse.emf.common.util.URI uriPhysicalOrLogical = ofNullable(uri)
		                    .orElseGet(() ->
		                          «IF config.resolveModelName.blank»
		                              createURI(name + "-«modelName.decapitalize».model"));
		                          «ELSE»
		                              createURI("«modelName.decapitalize».model"));
		                          «ENDIF»
		
		
		            «modelName»ModelResourceSupport «modelName.decapitalize»ModelResourceSupport = this.«modelName.decapitalize»ModelResourceSupport;
		            if (!«modelName.decapitalize»ModelResourceSupport$set) {
		                «modelName»ModelResourceSupport.«modelName»ModelResourceSupportBuilder «modelName.decapitalize»ModelResourceSupportBuilder =
		                        «modelName»ModelResourceSupport.«modelName.decapitalize»ModelResourceSupportBuilder()
		                                .uri(uriPhysicalOrLogical);
		
		                if (resourceSet$set) «modelName.decapitalize»ModelResourceSupportBuilder.resourceSet(resourceSet);
		                if (uriHandler$set) «modelName.decapitalize»ModelResourceSupportBuilder.uriHandler(uriHandler);
		
		                «modelName.decapitalize»ModelResourceSupport = «modelName.decapitalize»ModelResourceSupportBuilder.build();
		            } else {
		                this.uri = «modelName.decapitalize»ModelResourceSupport.getResource().getURI();
		            }
		
		            «IF config.resolveModelVersion.blank»
		            String version = this.version;
		            if (!version$set) version = LoadArguments.$default$version();
		            «ENDIF»
		
		            return new «modelName»Model(
		                «IF config.resolveModelName.blank»name,«ENDIF»
		                «IF config.resolveModelVersion.blank»version,«ENDIF»
		                uriPhysicalOrLogical,
		                «modelName.decapitalize»ModelResourceSupport);
		        }
		
		        @java.lang.Override
		        public java.lang.String toString() {
		            return "«modelName»Model.«modelName»ModelBuilder("
		                    «IF config.resolveModelName.blank»
		                    + "name=" + this.name + ", "
		                    «ENDIF»
		                    «IF config.resolveModelVersion.blank»
		                    + "version=" + this.version + ", " 
		                    «ENDIF»
		                    + "uri=" + this.uri
		                    + ", «modelName.decapitalize»ModelResourceSupport=" + this.«modelName.decapitalize»ModelResourceSupport + ")";
		        }
		    }
		
		    public static «modelName»ModelBuilder build«modelName»Model() {
		        return new «modelName»ModelBuilder();
		    }
		
		    private «modelName»Model(
		                     «IF config.resolveModelName.blank»
		                     final String name,
		                     «ENDIF»
		                     «IF config.resolveModelVersion.blank»
		                     final String version,
		                     «ENDIF»
		                     final URI uri,
		                     final «modelName»ModelResourceSupport «modelName.decapitalize»ModelResourceSupport) {
		
		        «IF config.resolveModelName.blank»
		        requireNonNull(name, "Name is mandatory");
		        «ENDIF»
		        requireNonNull(uri, "URI is mandatory");
		        «IF config.resolveModelName.blank»		
		        this.name = name;
		        «ENDIF»
		        «IF config.resolveModelVersion.blank»
		        this.version = version;
		        «ENDIF»
		        this.uri = uri;
		        this.«modelName.decapitalize»ModelResourceSupport = «modelName.decapitalize»ModelResourceSupport;
		    }
		
		    @java.lang.Override
		    public java.lang.String toString() {
		        return "«modelName»Model("
		                «IF config.resolveModelName.blank»
		                + "name=" + this.getName()
		                «ENDIF»
		                «IF config.resolveModelVersion.blank»
		                + ", version=" + this.getVersion()
		                «ENDIF»
		                + ", uri=" + this.getUri()
		                + ", «modelName.decapitalize»ModelResourceSupport=" + this.«modelName.decapitalize»ModelResourceSupport + ")";
		    }
		
		    /**
		     * Get the {@link URI} of the model.
		     */
		    public URI getUri() {
		        return this.uri;
		    }		
		}
	'''
}